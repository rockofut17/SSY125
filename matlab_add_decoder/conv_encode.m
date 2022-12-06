function bits_en = conv_encode(bits_in,G)

% Convolutional encoder, R=1/2， G = (1 + D^2 , 1 + D + D^2)

% G = [1,0,1;1,1,1];

[n , N] = size(G);

% zero-termination [data, 0, 0]
bits_in_add0 = [bits_in,zeros(1,N-1)];

D_0 = zeros(1,length(bits_in_add0));
D_1 = zeros(1,length(bits_in_add0));
D_2 = zeros(1,length(bits_in_add0));
tran = zeros(1,length(bits_in_add0));
bits_en = zeros(1, length(bits_in_add0)*n);


for i = 1:length(bits_in_add0)

    % suppose initial state (0,0) 00,data , so the first data bits protected by the 00 
    % data,00
    % add N bits 0 in the end, so the last states(output) must be 00
 
    if i == 1

        D_0(i) = bits_in_add0(i);
        D_1(i) = 0;
        D_2(i) = 0;

        bits_en(2*i-1) = xor(D_0(i),D_2(i));
        tran(i) = xor(D_0(i),D_1(i));
        bits_en(2*i) = xor(tran(i),D_2(i));

    else

        D_0(i) = bits_in_add0(i);
        D_1(i) = D_0(i-1);
        D_2(i) = D_1(i-1);

        bits_en(2*i-1) = xor(D_0(i),D_2(i));
        tran(i) = xor(D_0(i),D_1(i));
        bits_en(2*i) = xor(tran(i),D_2(i));

    end

end

end
    
