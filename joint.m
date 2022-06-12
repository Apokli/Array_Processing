function [theta, f] = joint(X,d,m)
% joint - Joint estimation of directions and frequencies
%                   
% Inputs:
%   X - the signals received at antennas
%   d - the number of sources
%   m - smoothing factor
M=size(X,1);
N=size(X,2);
d=2;
m=5;
X1=zeros(M*m,N-m+1);
for k=0:(m-1)
    for p=1:N-m+1
        X1(k*M+1:(k+1)*M,p)=X(:,p+k);
    end
end  

    [U,S,V]=svd(X1);
    U1=U(:,1:d);
    r1=rank(U1);

    d1=[eye(m-1),zeros(m-1,1)]; 
    e1=[zeros(m-1,1),eye(m-1)];
    Jx1=kron(d1,eye(M));
    Jy1=kron(e1,eye(M));

    p1=[eye(M-1),zeros(M-1,1)];
    q1=[zeros(M-1,1),eye(M-1)];
    Jx2=kron(eye(m),p1);
    Jy2=kron(eye(m),q1);

   Ux1=Jx1*U1;
   Uy1=Jy1*U1;
   Ux2=Jx2*U1;
   Uy2=Jy2*U1;

   M1= pinv(Ux1)* Uy1;
   M2= pinv(Ux2)* Uy2;
   MM(:,:,1)=M1;
   MM(:,:,2)=M2;
    
   [A1,LL] = acdc(MM);
   L1=LL(:,:,1);
   L2=LL(:,:,2);

%     [evc, eva]=eig(L1);
    eva1 = (diag(L2)).';
    theta = sort(asin(angle(eva1)/pi)*180/pi);

%     [evc, eva]=eig(L2);
    eva2 = (diag(L1)).';
    f = sort(angle(eva2)/(2*pi));


end

