function r=step_pid(param)
dt=0.001;
%parametros de planta
m=100;
w=0.1*4*pi;
k=w*w*m;
zita=0.1;
c=zita*2*m*w;

%CI 
v_act=0;
x_act=0;
sp=3;
I=0;
D=sp/dt;
%D=0;
sum3=0;

i=0;%indice de iteracion
sum2=0;

%parametros de control
kp_base=param(1);  
ki_base=param(2);
kd_base=param(3);

kp=kp_base;  
ki=ki_base;
kd=kd_base;

dkp=0;
dki=0;
dkd=0;
% 
% dkp=0;
% dki=0;
% dkd=0;

%contadores y sumatorias
c=0;
j=0;
i=0;
Cmax=1/dt;%%definirlo bien choto
%Cmax=param(8);
Errmax=1;
Var_max=100*Errmax*sqrt(Cmax)/Cmax;%%definirlo bien choto
sum1=0;
r=0; %%ritmo de decaimiento

T=10;
for t=0:dt:T %%diez segundos
    i=i+1;
    
    
    
    
    %PID
    P=kp*(sp-x_act);
    sum2=sum2+(sp-x_act)*dt;
    I=ki*sum2;
    
    
    
    
    %PID(i)=P+I+D;
     PID=P+I+D;
    %sum3=sum3+abs(PID(i));
    %cost(i)=sum3;
    %formmula recursiva
    x_sig= (dt^2)/(2*m)*(PID-c*v_act-k*x_act)+x_act+dt*v_act;
    x(i)=x_sig;
    
    
    
    D=kd*(x_sig-x_act)/dt;%no puede estar antes porque necesita el dato x_sig para ser calculado
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
            
            
            %%actualizar kp ki kd
            kp=kp_base-((1-(var/Var_max))^r*dkp);
            ki=ki_base-((var/Var_max))^r*dki;
            kd=kd_base+sqrt(((var/Var_max)))^r*dkd;
           
            
    %
    
    
    %actalizar
    x_act=x_sig;
    vact=(x_sig-x_act)/dt;
    
end

r=x;
end