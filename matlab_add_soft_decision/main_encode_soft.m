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
% 

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
    trellis = poly2trellis(3,[5,7]);
  % bits_enc = convenc(tx_bit,trellis);
  
  G1 = [1,0,1;1,1,1];
  bits_enc = conv_encode(tx_bit,G1);


  % [MOD] symbol mapper
  
  [mod_outI,mod_outQ]=qpsk_modulation(bits_enc);

  tx_sym = mod_outI+1i*mod_outQ; 

  % scatterplot(tx_sym);

  % [CHA] add Gaussian noise

  EbN0_value = 10^(EbN0(i)/10);
  R = length(tx_bit)/length(tx_sym);
  SNR = R * EbN0_value; 


  sigma2 = 1/(SNR*2);
  noise = sqrt(sigma2)*(randn(1,length(tx_sym)) + 1i*randn(1,length(tx_sym)));
  rx_data = tx_sym + noise;
  

  % soft receiver

  %dec = zeros(1,2*(N+2));
  %[~,dec(1:2:end)] = quantiz(real(rx_data),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7:-1:0]); 
  %[~,dec(2:2:end)] = quantiz(imag(rx_data),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7:-1:0]);
  %bits_out = vitdec(dec,trellis,16,'term','soft',3);
  %bits_out = bits_out(1:end-2); 

  rx_dec = conv_soft(rx_data,G1);
  bits_out = rx_dec(1:N);


  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  
  BitErrs = length(find(bits_out ~= tx_bit)); % count the bit errors and evaluate the bit error rate
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
semilogy(EbN0, BER,'r-*','DisplayName','coded system(soft)'); 
ylim([1e-4 1]);
hold on
grid on
%legend('coded system','uncoded system(simulation)','uncoded system(theory)')
legend
xlabel('EbN0(dB)');
ylabel('BER');