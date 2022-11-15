%chanDatasetPath = fullfile(matlabroot,'toolbox','nnet', ...
%    'nndemos','nndatasets','DigitDataset');

imagesDir = "c:\Users\netlab\Desktop\DeepMIMO-5GNR2\Normalized_Real\";

imds = imageDatastore(imagesDir,'ReadFcn',@matRead,'FileExtensions','.mat', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds.ReadSize = 500;
imds = shuffle(imds);

[imdsTrain,imdsVal,imdsTest] = splitEachLabel(imds,0.95,0.025);

dsTrainNoisy = transform(imdsTrain,@addNoise);
dsValNoisy = transform(imdsVal,@addNoise);
dsTestNoisy = transform(imdsTest,@addNoise);

dsTrain = combine(dsTrainNoisy,imdsTrain);
dsVal = combine(dsValNoisy,imdsVal);
dsTest = combine(dsTestNoisy,imdsTest);

dsTrain = transform(dsTrain,@commonPreprocessing);
dsVal = transform(dsVal,@commonPreprocessing);
dsTest = transform(dsTest,@commonPreprocessing);

% dsTrain = transform(dsTrain,@augmentImages);

exampleData = preview(dsTrain);
inputs = exampleData(:,1);
responses = exampleData(:,2);
minibatch = cat(2,inputs,responses);
montage(minibatch','Size',[8 2])
title('Inputs (Left) and Responses (Right)')


imageLayer = imageInputLayer([28,120,1]);

encodingLayers = [ ...
    convolution2dLayer(3,16,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2), ...
    convolution2dLayer(3,8,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2), ...
    convolution2dLayer(3,8,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2)];

decodingLayers = [ ...
    createUpsampleTransponseConvLayer(2,8), ...
    reluLayer, ...
    createUpsampleTransponseConvLayer(2,8), ...
    reluLayer, ...
    createUpsampleTransponseConvLayer(2,16), ...
    reluLayer, ...
    convolution2dLayer(3,1,'Padding','same'), ...
    clippedReluLayer(1.0), ...
    regressionLayer];  

layers = [imageLayer,encodingLayers,decodingLayers];

% options = trainingOptions('adam', ...
%     'MaxEpochs',100, ...
%     'MiniBatchSize',imds.ReadSize, ...
%     'ValidationData',dsVal, ...
%     'Plots','training-progress', ...
%     'Verbose',false);

deepNetworkDesigner(layers);
%net = trainNetwork(dsTrain,layers,options);

%modelDateTime = string(datetime('now','Format',"yyyy-MM-dd-HH-mm-ss"));
%save(strcat("trainedImageToImageRegressionNet-",modelDateTime,".mat"),'net');   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dataOut = addNoise(data)

    dataOut = data;
    for idx = 1:size(data,1)
       dataOut{idx} = imnoise(data{idx},'salt & pepper');
    end

end

function dataOut = addNoise_2(data)

    %dataOut = data;
    n_of_blank = randi([10,40],1);

    
    for idx = 1:size(data,1)
        data_Temp = data{idx};
        chan_Image_Trunc_1 = data_Temp(:,:,1);
        chan_Image_Trunc_2 = data_Temp(:,:,2);
        chan_Image_Trunc_3 = data_Temp(:,:,3);
        
        for j = 1:256 
            for k = 1:n_of_blank
                y_axis = randi([1,64]); 
                chan_Image_Trunc_1(j,y_axis)=0;
                chan_Image_Trunc_2(j,y_axis)=0;
            end   
        end
        
    dataOut(:,:,1) = chan_Image_Trunc_1;
    dataOut(:,:,2) = chan_Image_Trunc_2;
    dataOut(:,:,3) = 0.5500;

    end

end

function dataOut = commonPreprocessing(data)

    dataOut = cell(size(data));
    for col = 1:size(data,2)
        for idx = 1:size(data,1)
            temp = single(data{idx,col});
            %temp = imresize(temp,[180,28]);
            %temp = rescale(temp);
            dataOut{idx,col} = temp;
        end
    end
end

function dataOut = augmentImages(data)

    dataOut = cell(size(data));
    for idx = 1:size(data,1)
        rot90Val = randi(4,1,1)-1;
        dataOut(idx,:) = {rot90(data{idx,1},rot90Val),rot90(data{idx,2},rot90Val)};
    end
end

function out = createUpsampleTransponseConvLayer(factor,numFilters)

    filterSize = 2*factor - mod(factor,2); 
    cropping = (factor-mod(factor,2))/2;
    numChannels = 1;
    
    out = transposedConv2dLayer(filterSize,numFilters, ... 
        'NumChannels',numChannels,'Stride',factor,'Cropping',cropping);
end

function data = matRead(filename)
    inp = load(filename);
    f = fields(inp);
    data = inp.(f{1});
end