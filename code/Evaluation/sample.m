function vout = sample (vin, nbins)

nm = size(vin,1);
vout = zeros(nbins,1);

for i = 1: nbins
    ivin = ceil(i*nm/nbins);
    vout(i) =  vin(ivin);
end

end