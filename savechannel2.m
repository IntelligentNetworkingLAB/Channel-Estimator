bs = 1;
total_Users = 1810;
channel_Matrix = zeros(28,612,3);

for i = 1:total_Users
    for ris_Antenna = 1 : 64
        channel = DeepMIMO_dataset{bs}.user{i}.channel;
        channel_plot = (squeeze(channel(:, 1, ris_Antenna, :)));
        [l,c] = size(channel_plot);

        if l ~= 28
            i = i+1;
        else
            subcarriers = 1:dataset_params.OFDM_sampling_factor:dataset_params.OFDM_limit;
            OFDM_symbols = 1:1:(14*dataset_params.CDL_5G.num_slots);
            channel_plot_r = real(channel_plot);
            channel_plot_i = imag(channel_plot);
            channel_Matrix(:,:,1) = channel_plot_r;
            channel_Matrix(:,:,2) = channel_plot_i;
            file_Name = "True_" + "RIS_Antenna_" + ris_Antenna + "_to_UE_" + i + ".mat";
            save("c:\Users\netlab\Desktop\DeepMIMO-5GNR2\Channel_RIS_to_UE\" + file_Name,'channel_Matrix');
        end
    end
end