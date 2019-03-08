clear;
clc;
x = [1 2 3 4 5];

a = [1 2 3];
b = [4 5 6];

CI = [0 0];

if length(a)-1 ~= length(CI)
    return
end

N = length(a);
M = length(b);

temp1 = 0;
temp2 = 0;

for n = 1 : length(x)
    for k = 2 : N
        if n-k+1 < 1
            temp1 = temp1 + (a(k)/a(1))*CI((n-k)*-1);
        else
            temp1 = temp1 + (a(k)/a(1))*y(n-k+1);
        end
    end
    
    for j = 1 : M
        if n-j+1 < 1 || n-j > length(x)-1
            temp2 = temp2;
        else
            temp2 = temp2 + (b(j)/a(1))*x(n-j+1);
        end
    end
    y(n) = -temp1 + temp2;
    temp1 = 0;
    temp2 = 0;
end
y
stem(x)
hold on
stem(y)