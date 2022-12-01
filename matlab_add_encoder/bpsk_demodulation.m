function data_out=bpsk_demodulation(data_in)
L = length(data_in);
data_out = zeros(1,L);

for k=1:L
    if (data_in(k)>0)
        data_out(k)=1;
    else
        data_out(k)=0;

end