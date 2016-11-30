% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL

function [net,performance] = MLFFNN_ind_43(inputs,targets,Indices)
    
    % Create a Pattern Recognition Network
    hiddenLayerSize = [150,150];
    net = patternnet(hiddenLayerSize);
    
    net.trainParam.max_fail = 1000;
    %net.trainParam.min_grad = 1e-6;
    net.trainParam.epochs = 1500;
    
    net.divideFcn = 'divideind';
    % Set up Division of Data for Training, Validation, Testing
    net.divideParam.trainInd = Indices.train;
    net.divideParam.valInd = Indices.val;
    net.divideParam.testInd = Indices.test;

    % Train the Network
    [net,tr] = train(net,inputs,targets);

    % Test the Network
    outputs = net(inputs);
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs)

    % View the Network
    view(net)

    % Plots
    % Uncomment these lines to enable various plots.
    % figure, plotperform(tr)
    % figure, plottrainstate(tr)
    % figure, plotconfusion(targets,outputs)
    % figure, ploterrhist(errors)
end