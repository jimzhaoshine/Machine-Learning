function [a,b,c,d,T] = ellipticFourierDescriptor(x,y,N)

m = size(x, 1);

% Calculate the delta t's and the total period
dt = zeros(N,1);
for jt = 1:m
    jt1 = mod(jt-2, N) + 1;
    deltaX = x(jt) - x(jt1);
    deltaY = y(jt) - y(jt1);
    dt(jt) = sqrt(deltaX^2 + deltaY^2);
end

T = sum(dt);

% Calculate the coefficiencts
% Please note: This is not a fast fourier transform!
a = zeros(N,1);
b = zeros(N,1);
c = zeros(N,1);
d = zeros(N,1);
for it = 1:N
    a(it) = coeffA(it,m,T,dt,x,y);
    b(it) = coeffB(it,m,T,dt,x,y);
    c(it) = coeffC(it,m,T,dt,x,y);
    d(it) = coeffD(it,m,T,dt,x,y);
end


% Normalize the coefficients
% --------------------------

% 1. Phase invariance
% This is needed to receive the same fourier descriptor no matter which
% order of points you pick
% Normalizes the phase according to [1]
delta = 0.5*atan(2*(a(1)*b(1)+c(1)*d(1))/sqrt(a(1)^2+b(1)^2+c(1)^2+d(1)^2));
for it = 1:N
    M = [a(it), b(it);c(it), d(it)];
    K = [cos(it*delta), -sin(it*delta);sin(it*delta), cos(it*delta)];
    B = M*K;
    a(it) = B(1,1);
    b(it) = B(1,2);
    c(it) = B(2,1);
    d(it) = B(2,2);
end


% Extract the scale-invariance to use it later
E = sqrt(a(1)^2+c(1)^2);

% 2. Rotation invariance
% Normalizes the phase according to [1]
psi = atan(c(1)/a(1));
K = [cos(psi), sin(psi);-sin(psi), cos(psi)];
for it = 1:N
    M = [a(it), b(it);c(it), d(it)];
    B = K*M;
    a(it) = B(1,1);
    b(it) = B(1,2);
    c(it) = B(2,1);
    d(it) = B(2,2);
end

end

function a = coeffA(n, m, T, dt, x, y)
% Calculates the coefficient a_n
    a = 0;
    for jt = 1:m
        deltaX = x(jt) - x(mod(jt-2, m)+1);
        a = a + deltaX/dt(jt) * (cos(2*n*pi*ti(jt, dt)/T) - cos(2*n*pi*ti(jt-1, dt)/T));
    end
    a = a*T/(2*n^2*pi^2);
end

function b = coeffB(n, m, T, dt, x, y)
% Calculates the coefficient b_n
    b = 0;
    for jt = 2:m
        deltaX = x(jt) - x(mod(jt-2, m)+1);
        b = b + deltaX/dt(jt) * (sin(2*n*pi*ti(jt, dt)/T) - sin(2*n*pi*ti(jt-1, dt)/T));
    end
    b = b*T/(2*n^2*pi^2);
end

function c = coeffC(n, m, T, dt, x, y)
% Calculates the coefficient c_n
    c = 0;
    for jt = 1:m
        deltaY = y(jt) - y(mod(jt-2, m)+1);
        c = c + deltaY/dt(jt) * (cos(2*n*pi*ti(jt, dt)/T) - cos(2*n*pi*ti(jt-1, dt)/T));
    end
    c = c*T/(2*n^2*pi^2);
end

function d = coeffD(n, m, T, dt, x, y)
% Calculates the coefficient d_n
    d = 0;
    for jt = 1:m
        deltaY = y(jt) - y(mod(jt-2, m)+1);
        d = d + deltaY/dt(jt) * (sin(2*n*pi*ti(jt, dt)/T) - sin(2*n*pi*ti(jt-1, dt)/T));
    end
    d = d*T/(2*n^2*pi^2);
end

function t = ti(m, dt)
    t = 0;
    for it = 1:m
        t = t + dt(it);
    end
end