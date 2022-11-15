num_of_Users = 1810;
num_of_Elements = 64;
num_of_Antennas = 1;
for i = 1:num_of_Antennas
    for j = 1:num_of_Elements
        for k = 1:num_of_Users
            chan_Normalized = zeros(28,612,3);
            c_Chan = load("Cascaded\Cascaded_"+i+"_"+j+"_"+k);
            c_Matrix = c_Chan.cascaded_Channel;
            real = c_Matrix(:,:,1);
            imag = c_Matrix(:,:,2);
            real_min = min(min(real));
            imag_min = min(min(imag));
            real_Digits = get_Digits(real_min)+1;
            imag_Digits = get_Digits(imag_min)+1;
            chan_Normalized(:,:,1) = (real + abs(real_min))*10.^real_Digits;
            chan_Normalized(:,:,2) = (imag + abs(imag_min))*10.^imag_Digits;
            file_Name = "Normalized"+i+"_"+j+"_"+k + "_"+ real_Digits + "_" + imag_Digits;
            save("c:\Users\netlab\Desktop\DeepMIMO-5GNR2\Normalized\" + file_Name,'chan_Normalized');

        end
    end
end

function i = get_Digits(value)
    abs_Value = abs(value);
    j = 1;
    while(abs_Value<1)
        abs_Value = abs_Value * 10;
        j=j+1;
    end
    i = j-1;
end
