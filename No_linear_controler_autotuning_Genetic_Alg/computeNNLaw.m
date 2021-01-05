function U=computeNNLaw(param,features,n_hiden_layers,n_neurons)


exit_neurons=1;
n_neurons=[n_neurons exit_neurons];
n_features=length(features);
features=[1 features];%1er bias


a=features;


for i=1:n_hiden_layers+1
    i;
if i==1    
    count1=(n_features+1)*n_neurons(i);
    aux=param(1,1:count1);
    tita=reshape(aux,[n_features+1,n_neurons(i)]);
    
    %
    
    g=a*tita;
    if i~=(n_hiden_layers+1)%%no se le aplica sigmoidea ni se le agrega bias a la capa de salida
    
    a_sig=sigmoid(g);
    a_sig=[1 a_sig];
    a=a_sig;
    end
    %
    
else
    count1=count1+1;
    count2=count1+n_neurons(i)*(n_neurons(i-1)+1)-1;
    
    
    aux=param(1,count1:count2);
    tita=reshape(aux,n_neurons(i-1)+1,[n_neurons(i)]);
    count1=count2;
    
    %
   
    g=a*tita;
    if i~=(n_hiden_layers+1)%%no se le aplica sigmoidea ni se le agrega bias a la capa de salida
    
    a_sig=sigmoid(g);
    a_sig=[1 a_sig];
    a=a_sig;
    end
    %
    
end
    
end




U=g;
end

