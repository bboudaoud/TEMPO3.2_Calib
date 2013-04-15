rpm33 = importdata('33RPM_node116.csv');
rpm45 = importdata('45RPM_node116.csv');
calib = importdata('TEMPO3.2F-0116.csv');

t33 = rpm33(:,1);
t45 = rpm45(:,1);

a = calib(1,:);
b = calib(2,:);

figure;
plot(t33, rpm33(:, 5), t33, rpm33(:,6), t33, rpm33(:,7));
legend('X Gyro', 'Y Gyro', 'Z Gyro');
title('33 RPM Gyro (uncorrected)');

figure;
plot(t45, rpm45(:,5), t45, rpm45(:,6), t45, rpm45(:,7));
legend('X Gyro', 'Y Gyro', 'Z Gyro');
title('45 RPM Gyro (uncorrected)');

XG33 = a(1)*(rpm33(:,5) - b(1));
YG33 = a(2)*(rpm33(:,6) - b(2));
ZG33 = a(3)*(rpm33(:,7) - b(3));

XG45 = a(1)*(rpm45(:,5) - b(1));
YG45 = a(2)*(rpm45(:,6) - b(2));
ZG45 = a(3)*(rpm45(:,7) - b(3));
figure;
plot(t33, XG33, t33, YG33, t33, ZG33)
legend('X Gyro', 'Y Gyro', 'Z Gyro');
title('33 RPM Gyro (Corrected)');
figure; 
plot(t45, XG45, t45, YG45, t45, ZG45)
legend('X Gyro', 'Y Gyro', 'Z Gyro');
title('45 RPM Gyro (Corrected)');

