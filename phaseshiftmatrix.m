phaseshift_Matrix = zeros(28,612,1);

for i = 1:28

    for j = 1:612

        phaseshift_Matrix(i,j) = 1 * exp(pi/2 * 1i);

    end

end

file_Name = "Phaseshift_Matrix";
save("c:\Users\netlab\Desktop\DeepMIMO-5GNR2\PhaseshiftMat\" + file_Name,'phaseshift_Matrix');