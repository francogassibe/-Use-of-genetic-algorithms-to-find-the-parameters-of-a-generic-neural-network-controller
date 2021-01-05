clc 
clear

elem_features=[1 2 3 4 5 6];
degree=3;
for i=1:degree-1
     pol(i,:)=elem_features.^(i+1);
end
exps=exp(elem_features);
inv=1./(elem_features.^2+0.1);

%Crossover
% c=0;
% for i=1:length(elem_features)
%     for j=1:length(inv)
%         if (i~=j)
%             c=c+1;
%             cross1(c)=elem_features(i)*inv(j);
%         end
%     end
% end

c=0;
for i=1:length(elem_features)
    for j=1:length(elem_features)
        if (i~=j) 
            c=c+1;
            cross2(c)=elem_features(i)*elem_features(j);
        end
    end
end




pol=reshape(pol,1,[]);
% A=[elem_features pol exps inv cross2 cross1];
A=[elem_features pol exps inv cross2];
%A=[elem_features pol cross2];

num_features=length(A)