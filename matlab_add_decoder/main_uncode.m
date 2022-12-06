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

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
  
  tx_bit = randi([0 1],1,N);

  % [ENC] convolutional encoder
  % ...

  % [MOD] symbol mapper
  
  [mod_outI,mod_outQ]=qpsk_modulation(tx_bit);

  tx_sym = mod_outI+1i*mod_outQ; 

  % scatterplot(tx_data);

  % [CHA] add Gaussian noise

  EbN0_value = 10^(EbN0(i)/10);
  R = length(tx_bit)/length(tx_sym);
  SNR = R * EbN0_value; 
  % rx_data = awgn(tx_sym,SNR,'measured');

  sigma2 = 1/(SNR*2);
  noise = sqrt(sigma2)*(randn(1,length(tx_sym)) + 1i*randn(1,length(tx_sym)));
  rx_data = tx_sym +noise;
  
  % scatterplot(rx_data);


  % demodulation

  [demod_outI,demod_outQ]=qpsk_demodulation(rx_data);

  bit_out = P2SConverter(demod_outI,demod_outQ);


  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  
  BitErrs = length(find(bit_out ~= tx_bit)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 

  disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
      num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
      num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
end

% plots
figure(1)  
semilogy(EbN0, BER,'b-*'); 
ylim([1e-4 1]);
hold on
grid on
%legend('QPSK without encode')
xlabel('EbN0(dB)');
ylabel('BER');

% ======================================================================= %
% End
% ======================================================================= %