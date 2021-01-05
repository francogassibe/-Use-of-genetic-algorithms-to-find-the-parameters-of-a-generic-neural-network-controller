function J=LQRpid(param)


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


sum2=0;

%parametros de control
kp=param(1);  
ki=param(2);
kd=param(3);



%contadores y sumatorias
i=0;


flag=1;
tol=0.1;
tiemposubida=100;
tiempoest=100;
T=10;
for t=0:dt:T %%diez segundos
    i=i+1;
    
    
    
    
    %PID
    P=kp*(sp-x_act);
    sum2=sum2+(sp-x_act)*dt;
    I=ki*sum2;
    
    
    
    
    %PID(i)=P+I+D;
     PID=P+I+D;

    %formmula recursiva
    x_sig= (dt^2)/(2*m)*(PID-c*v_act-k*x_act)+x_act+dt*v_act;
    x(i)=x_sig;
    
    
    
    
    D=kd*(x_sig-x_act)/dt;%no puede estar antes porque necesita el dato x_sig para ser calculado
    %es decir la iteracion 1 usa D=sp/dt y la iteracion 2 usa un primer valor
    %de D calculado.
    
    
    
    if ( (abs(sp-x_act)<=tol) && (abs(x_sig-x_act)<=tol*0.1) )
        tiempoest=i*dt;
    end
    
   
    if flag==1
        if abs(sp-x_act)<=tol
            tiemposubida=i*dt;
            flag=2;
        end
    end
    
    
    
    %actalizar
    x_act=x_sig;
    vact=(x_sig-x_act)/dt;
end

%J=sum((sp-x).^2)+10*tiemposubida+tiempoest;
J=sum((sp-x).^2);
end