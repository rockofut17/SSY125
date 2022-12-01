function bits_en = conv_encode(bits_in)

% Convolutional encoder, R=1/2， G = (1 + D^3 + D^4 , 1 + D + D^3 + D^4)


% g(1) = [1,0,1]   g(2) =[1,1,1]
% use matlab function
% trellis = poly2trellis(3,[5,7]);
% bits_en_1 = convenc(bits_in,trellis);

R = 1/2;

D_0 = zeros(1,length(bits_in));
D_1 = zeros(1,length(bits_in));
D_2 = zeros(1,length(bits_in));
D_3 = zeros(1,length(bits_in));
D_4 = zeros(1,length(bits_in));
tran_b1 = zeros(1,length(bits_in));
tran_b2_1 = zeros(1,length(bits_in));
tran_b2_2 = zeros(1,length(bits_in));
bits_en = zeros(1, length(bits_in)/R);

for i = 1:length(bits_in)

    % initial state (0,0)
    if i == 1

        D_0(i) = bits_in(i);
        D_1(i) = D_0(i);
        D_2(i) = D_1(i);
        D_3(i) = D_2(i);
        D_4(i) = D_3(i);
        tran_b1(i)=xor(D_0(i),D_3(i));
        bits_en(2*i-1) = xor(D_4(i),tran_b1(i));
        tran_b2_1(i) = xor(D_0(i),D_1(i));
        tran_b2_2(i) = xor(tran_b2_1(i),D_3(i))
        bits_en(2*i) = xor(tran_b2_2(i),D_4(i));

    else

        D_0(i) = bits_in(i);
        D_1(i) = D_0(i-1);
        D_2(i) = D_1(i-1);
        D_3(i) = D_2(i-1);
        D_4(i) = D_3(i-1);
        tran_b1(i)=xor(D_0(i),D_3(i));
        bits_en(2*i-1) = xor(D_4(i),tran_b1(i));
        tran_b2_1(i) = xor(D_0(i),D_1(i));
        tran_b2_2(i) = xor(tran_b2_1(i),D_3(i))
        bits_en(2*i) = xor(tran_b2_2(i),D_4(i));

    end

end

end
    
