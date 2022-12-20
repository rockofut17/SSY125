function bits_en = encoder_e4_nzt(bits_in)
    D_1=0;
    D_2=0;
    D_3=0;
    a=2;
    b=3;
    R=a/b;
    c_1=0;
    c_2=0;
    c_3=0;
    bits_en = zeros(1, length(bits_in)/R);
    j=0;
    for i=1:a:length(bits_in)
        c_1=D_3;
        c_2=bits_in(i);
        c_3=bits_in(i+1);
        D_1=D_3;
        D_2=xor(bits_in(i+1),D_1);
        D_3=xor(bits_in(i),D_2);
        bits_en(i+j)=c_1;
        bits_en(i+j+1)=c_2;
        bits_en(i+j+2)=c_3;
        j=j+1;
    end

end