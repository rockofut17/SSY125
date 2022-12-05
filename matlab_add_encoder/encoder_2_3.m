function bits_en = encoder_e4_nzt(bits_in)
    D_1=0;
    D_2=0;
    D_3=0;
    R=2/3;
    c_1=0;
    c_2=0;
    c_3=0;
    bits_en = zeros(1, length(bits_in)/R);
    trans=0;
    if mod(length(bits_in),2)=0
        for i=1:2:length(bits_in)
            c_1=D_3;
            c_2=bits_in(i);
            c_3=bits_in(i+1);
            bits_en(3*i-2)=c_1;
            bits_en(3*i-1)=c_2;
            bits_en(3*i)=c_3;
            trans=D_3;
            D_3=xor(bits_in(i),D_2);
            D_2=xor(bits_in(i+1),D_1);
            D_1=trans;
         end

    else

    end
            

end