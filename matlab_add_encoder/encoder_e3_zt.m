function bits_en = encoder_e3_zt(bits_in)
    % Convolutional encoder, R=1/2， G = (1 + D_3 + D_4, 1 + D + D_3 + D_4)
    D_0=0;
    D_1=0;
    D_2=0;
    D_3=0;
    D_4=0;
    States=5;
    R=1/2;
    bits_en = zeros(1, (length(bits_in)/R)+(States*2));
    tmp=0;
    for i=1:length(bits_in)
        D_4=D_3;
        D_3=D_2;
        D_2=D_1;
        D_1=D_0;
        D_0=bits_in(i);
        bits_en(2*i-1)=xor(xor(D_0,D_3),D_4);
        bits_en(2*i)=xor(xor(D_0,D_1),xor(D_3,D_4));
    end
    for i=1:States
        D_4=D_3;
        D_3=D_2;
        D_2=D_1;
        D_1=D_0;
        D_0=0;
        bits_en((length(bits_in)/R)+2*i-1)=xor(xor(D_0,D_3),D_4);
        bits_en((length(bits_in)/R)+2*i)=xor(xor(D_0,D_1),xor(D_3,D_4));
    end

end






