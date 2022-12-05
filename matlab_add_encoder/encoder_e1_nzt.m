function bits_en = encoder_e1_nzt(bits_in)
    % Convolutional encoder, R=1/2， G = (1 + D^2 , 1 + D + D^2)
    D_0=0;
    D_1=0;
    D_2=0;
    States=3;
    R=1/2;
    bits_en = zeros(1, (length(bits_in)/R));
    tmp=0;
    for i=1:length(bits_in)
        D_2=D_1;
        D_1=D_0;
        D_0=bits_in(i);
        bits_en(2*i-1)=xor(D_0,D_2);
        tmp=xor(D_0,D_1);
        bits_en(2*i)=xor(tmp,D_2);
    end
end