function F1 = evaluate(vecBlur, vecDark, ANOTS, thW, thBl, thBr)
res = ones(numel(ANOTS),1);
thBl = 1 -thBl;

for i = 1: numel(ANOTS)
    blur = vecBlur(i);
    dark = vecDark(i);
%     if(blur > thBr || dark < thBl || dark > thW )
    if(  blur > thBr  )
        res(i) = 0;
    end
end

Accuracy = (sum(ANOTS & res) + sum(~ANOTS & ~res))/numel(ANOTS);
Precision = sum(~ANOTS & ~res) / sum(~ANOTS);
Recall = sum(~ANOTS & ~res) / sum(~res);

F1 = 2* Precision *Recall / (Precision + Recall+0.001);
end