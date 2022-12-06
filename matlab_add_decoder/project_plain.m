% ======================================================================= %
% SSY125 Project
% ======================================================================= %
clc
clear

% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range

% ======================================================================= %
% Other Options
% ======================================================================= %
% ...

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results
BER_unc = zeros(1, length(EbN0)); 

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr_unc = 0;
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
  
  tx_bit = randi([0 1],1,N);

  % [ENC] convolutional encoder

  G1 = [1,0,1;1,1,1];
  tx_enc = conv_encode(tx_bit,G1);

  % [MOD] symbol mapper
  
  [mod_outI,mod_outQ]=qpsk_modulation(tx_enc);
  tx_sym = mod_outI + 1i*mod_outQ;
  
  
  [mod_outI_unc,mod_outQ_unc]=qpsk_modulation(tx_bit);
  tx_sym_unc = mod_outI_unc + 1i*mod_outQ_unc; 

  % scatterplot(tx_data);

  % [CHA] add Gaussian noise

  EbN0_value = 10^(EbN0(i)/10);
  % R = length(tx_bit)/length(tx_sym);
  % SNR = R * EbN0_value; 
  % rx_data = awgn(tx_sym,SNR,'measured');

  sigma = 1/(EbN0_value*0.5*2*2);
  noise = sqrt(sigma)*(randn(1, length(tx_sym)) + 1i*length(tx_sym)); 
  rx_data = tx_sym + noise;

  sigma_unc = 1/(EbN0_value*2*2);
  noise_unc = sqrt(sigma_unc)*(randn(1,length(tx_sym_unc)) + 1i*randn(1,length(tx_sym_unc))); 
  rx_data_unc = tx_sym_unc + noise_unc;

  % scatterplot(rx_data);

  % [SR] Soft Receiver

  % demodulation

  [demod_outI,demod_outQ]=qpsk_demodulation(rx_data);
  bit_out = P2SConverter(demod_outI,demod_outQ);


  [demod_outI_unc,demod_outQ_unc]=qpsk_demodulation(rx_data_unc);
  bit_out_unc = P2SConverter(demod_outI_unc,demod_outQ_unc);


  % [HR] Hard Receiver
  
  rx_de = conv_hard(bit_out,G1);
  rx_bit = rx_de(1:N);


  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  
  BitErrs = length(find(rx_bit ~= tx_bit)); % count the bit errors and evaluate the bit error rate

  totErr = totErr + BitErrs;
  num = num + N; 

  BitErrs_unc = length(find(bit_out_unc ~= tx_bit));
  totErr_unc = totErr_unc + BitErrs_unc;

  disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
      num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
      num2str(totErr/num, '%10.1e') '. +++']);



  end 
  BER(i) = totErr/num; 

  BER_unc(i) = totErr_unc/num; 

end

% plots
figure(1)  
plot(EbN0, BER,'b-+',EbN0, BER_unc,'r-*'); 
hold on
grid on
legend('Convolutional code with hard decision','QPSK without encode')
xlabel('EbN0(dB)');
ylabel('BER');
% title('');

%figure(2)  
%semilogy(EbN0, BER_unc,'r-*'); 
%hold on
%grid on
%legend('QPSK without encode')
%xlabel('EbN0(dB)');
%ylabel('BER');

% ======================================================================= %
% End
% ======================================================================= %