trellis = poly2trellis(3,{'x2+1','x2+x+1'});
EbN0 = 0:8;
spect = distspec(trellis,10);
dmin = spect.dfree;
Ad = spect.event;
dx = spect.weight;
Pb_soft = zeros(1,length(EbN0));
for i = 1:length(EbN0)
     EbN0_value = 10^(EbN0(i)/10);
    for d = dmin:length(Ad)
        Pb_soft(i) = Pb_soft(i) + Ad(d)*qfunc(sqrt(dx(d)*EbN0_value));
    end
end

semilogy(EbN0, Pb_soft,'g--','DisplayName','Upperbound eps3','LineWidth',2.0);
grid on
ylim([1e-4 1]);
