function vecW =  learnWeights (evls, methods)
    AUCS = zeros(1,numel(evls));
    for m = 1 : numel(evls)
        AUCS(m) = evls{m}.getAUC();
    end
    
    vecW = AUCS / sum(AUCS);
    
    fprintf('Learned Weights for each method:\n');
    T = table(methods', vecW', 'VariableNames', {'methods', 'ponderation'});
    disp(T);

end