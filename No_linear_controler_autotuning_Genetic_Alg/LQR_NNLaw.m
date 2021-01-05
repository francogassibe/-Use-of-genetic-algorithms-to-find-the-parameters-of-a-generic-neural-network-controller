function J=LQR_NNLaw(param)


n_hiden_layers=2;
n_neurons=[20 5];


dt=0.001;
%parametros de planta
m=100;
w=0.1*4*pi;
k=w*w*m;
zita=0.1;
b=zita*2*m*w;

%CI 
acel_act=0;
v_act=0;
x_act=0;
sp=3;
D_err=(sp-x_act)/dt;

%ctes control
kp=9.7543*10^5;
ki=0.1381*10^5;
kd=0.9821*10^5;




%contadores y sumatorias

sum2=0;
c=0;
j=0;
i=0;
Cmax=1/dt;%%definirlo bien choto
Cmax=800;
Errmax=1;
Var_max=100*Errmax*sqrt(Cmax)/Cmax;%%definirlo bien choto
sum1=0;
tol=0.01;
T=5;
flag=1;
tiemposubida=100;
tiempoest=100;
coefvar=(sp-x_act)^2/Var_max;
for t=0:dt:T %%diez segundos
    i=i+1;
    
    
    
    
    %PID
    errpos=(sp-x_act);
    sum2=sum2+(sp-x_act)*dt;
    
    
    elem_features=[errpos sum2 coefvar v_act D_err acel_act];
    features=createfeatures(elem_features);
    U_NNLaw=computeNNLaw(param,features,n_hiden_layers,n_neurons);
    PID=kp*errpos+ki*sum2+kd*D_err;
    U=PID+U_NNLaw;
    %formmula recursiva
    x_sig= (dt^2)/(2*m)*(U-b*v_act-k*x_act)+x_act+dt*v_act;
    v_sig=(x_sig-x_act)/dt;
    acel_act=(v_sig-v_act)/dt;
    x(i)=x_sig;
    errsig=(sp-x_sig);
    D_err=(errsig-errpos)/dt;%no puede estar antes porque necesita el dato x_sig para ser calculado
    %es decir la iteracion 1 usa D=sp/dt y la iteracion 2 usa un primer valor
    %de D calculado.
    
    
    %calculo varianza
     if (c<Cmax)
        c=c+1;
        v(c)=x(i);
        sum1=sum1+(sp-v(c))*(sp-v(c));
        var=(sqrt(sum1))/(c);
        
     end
    if(c==Cmax)
        j=j+1;
        sum1=sum1-(sp-v(j))*(sp-v(j));%%deberia indexar sub j;
        v(j)=x(i);
        sum1=sum1+(sp-v(j))*(sp-v(j));%aca tambn
        var=(sqrt(sum1))/Cmax;
        
        if (j==Cmax)
          j=0;
        end
    end
    varianzas(i)=var;
    coefvar=var/Var_max;
           
            
    %
    
    if ( (abs(sp-x_act)<=tol) && (abs(x_sig-x_act)<=tol*0.1) )
        tiempoest=i*dt;
    end
    
    
    
    %actalizar
    x_act=x_sig;
    v_act=v_sig;
    if flag==1
        if (sp-x_act)<=tol
            
            tiemposubida=i*dt;
            flag=2;
        end
    end
    
    
end
finish=1;
%J=sum((sp-x).^2)+tiemposubida+tiempoest;
J=sum((sp-x).^2);
end