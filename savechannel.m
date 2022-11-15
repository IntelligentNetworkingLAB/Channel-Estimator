bs = 1;
total_Users = 181;
channel_Matrix = zeros(28,612,3);
ue=90;

for bs_Antenna = 1:1
    for ris_Antenna = 1:64
        channel = DeepMIMO_dataset{bs}.user{ue}.channel;
        channel_plot = squeeze(channel(:, bs_Antenna, ris_Antenna, :));
        subcarriers = 1:dataset_params.OFDM_sampling_factor:dataset_params.OFDM_limit;
        OFDM_symbols = 1:1:(14*dataset_params.CDL_5G.num_slots);
        channel_plot_r = real(channel_plot);
        channel_plot_i = imag(channel_plot);
        channel_Matrix(:,:,1) = channel_plot_r;
        channel_Matrix(:,:,2) = channel_plot_i;
        file_Name = "True" + bs_Antenna + "to" + ris_Antenna + ".mat";
        save("c:\Users\netlab\Desktop\DeepMIMO-5GNR2\Channel_BS_to_RIS\" + file_Name,'channel_Matrix');
    end
end

% figure;
% 
% subplot(2 ,1, 1);
% surf(OFDM_symbols, subcarriers, channel_plot');
% shading('flat');
% xlabel('OFDM Symbols');
% ylabel('Subcarriers');
% zlabel('|H|');
% title('Channel Magnitude Response');
% view(-75, 35)
% 
% 
% subplot(2,1,2);
% imagesc(OFDM_symbols, subcarriers, channel_plot');
% set(gca,'YDir','normal') % Invert Y axis (subcarriers)
% shading('flat');
% xlabel('OFDM Symbols');
% ylabel('Subcarriers');
% zlabel('|H|');
% title('Channel Magnitude Response');
% view(0, 90)