tic
data1=fopen('struGridNoNoise1.txt');
struDB1 = textscan(data1,'%14.10f',[10003*6554 1]);
struDB1 = reshape(struDB1{1,1},10003,6554);

data2=fopen('struGridNoNoise2.txt');
struDB2 = textscan(data2,'%14.10f',[10003*6554 1]);
struDB2 = reshape(struDB2{1,1},10003,6554);

data3=fopen('struGridNoNoise3.txt');
struDB3 = textscan(data3,'%14.10f',[10003*6554 1]);
struDB3 = reshape(struDB3{1,1},10003,6554);

data4=fopen('struGridNoNoise4.txt');
struDB4 = textscan(data4,'%14.10f',[10003*6554 1]);
struDB4 = reshape(struDB4{1,1},10003,6554);

data5=fopen('struGridNoNoise5.txt');
struDB5 = textscan(data5,'%14.10f',[10003*6552 1]);
struDB5 = reshape(struDB5{1,1},10003,6552);
toc
save('struDB-32-32-32.mat','struDB1','struDB2','struDB3','struDB4','struDB5');
