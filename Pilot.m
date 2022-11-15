num_of_Users = 1810;
num_of_Elements = 64;
num_of_Antennas = 1;

transmitted_Signal = 1+1i;
pilot_Signal = 3+3i;
number_of_Pilot_Symbol = [8 10 12 14];
Pilot_Spacing = [2 4 6 8];

for i = 1:num_of_Antennas
    for j = 1:num_of_Elements
        for k = 1:num_of_Users
            
            c_Chan = load("Cascaded\Cascaded_"+i+"_"+j+"_"+k);
            channel = c_Chan.cascaded_Channel;
            channel_Real = channel(:,:,1);
            channel_Imag = channel(:,:,2);
            channel_Original = org_Channel(channel_Real,channel_Imag);
            dp_Matrix = make_Data_Pilot_Matrix(number_of_Pilot_Symbol,Pilot_Spacing,transmitted_Signal,pilot_Signal);
            %transmitted_Signal_Matrix = channel_Original.*dp_Matrix;
            file_Name = "Pilot_"+i+"_"+j+"_"+k;
            save("c:\Users\netlab\Desktop\DeepMIMO-5GNR2\Pilot\" + file_Name,'dp_Matrix');
        end
    end
end



% exampleObject = load("Cascaded\Cascaded_1_10_1");
% SNRdb = 10; % SNR 10db
% channel = exampleObject.cascaded_Channel;
% transmitted_Signal = 1+1i;
% pilot_Signal = 3+3i;
% channel_Real = channel(:,:,1);
% channel_Imag = channel(:,:,2);
% number_of_Pilot_Symbol = [2 4 6 8 10 12 14];
% Pilot_Spacing = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 32];
% SNR = 10^(SNRdb/10);
% channel_Original = org_Channel(channel_Real,channel_Imag);
% dp_Matrix = make_Data_Pilot_Matrix(number_of_Pilot_Symbol,Pilot_Spacing,transmitted_Signal,pilot_Signal);

function original_Channel = org_Channel(matrix_Real, matrix_Imag)

symbols = 28;
subCarriers = 612;

for i = 1:symbols
    for j = 1: subCarriers
        original_Channel(i,j) = complex(matrix_Real(i,j),matrix_Imag(i,j)); 
    end
end

end


function data_Pilot_Matrix = make_Data_Pilot_Matrix(sym_Array,carrier_Array,data_Symbol,pilot_Symbol)

    a = randi(size(sym_Array));
    number_of_symbol_for_Pilot = sym_Array(a); % Number of Pilots 

    b = randi(size(carrier_Array));

    symbol_Index = zeros(1,number_of_symbol_for_Pilot);
    spacing = carrier_Array(b);

    for r = 1:number_of_symbol_for_Pilot
        if(r>1)

            while(true)
                symbol_Index(r) = randi(28);
                chk = 0;            
                for m = 1:r-1
                    if(symbol_Index(m)==symbol_Index(r))
                        chk = 1;
                        break;
                    else
                        chk=0;
                    end
                end
                
                if(chk==0)
                    break;
                end
            end
        else
            symbol_Index(r) = randi(28);
        end
    end

    for i = 1:28
        for j = 1:612
            data_Pilot_Matrix(i,j) = data_Symbol;
        end
    end
   
    for l = 1:number_of_symbol_for_Pilot
        
        pilot_Index = symbol_Index(l);

        for k = 1:20
           
            
            index = spacing * k;

            if(index>612)
                break;
            end
                
            data_Pilot_Matrix(pilot_Index,index) = pilot_Symbol;
            
        end

    
    end

end

% function received_Signal = wireless_Channel()
% 
% 
% end

