% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by NPRTOOL

function [net,performance] = MLFFNN_ind(inputs,targets,Indices)
    
    % Create a Pattern Recognition Network
    hiddenLayerSize = [250,250];
    net = patternnet(hiddenLayerSize);
    
    net.trainParam.max_fail = 2000;
    net.trainParam.min_grad = 1.0e-4;
    net.trainParam.epochs = 3000;
    
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