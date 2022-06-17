load('impulse_responses.mat');
[y1,Fs1]=audioread('clean_speech.wav');
[y2,Fs2]=audioread('clean_speech_2.wav');
[y3,Fs3]=audioread('babble_noise.wav');
[y4,Fs4]=audioread('aritificial_nonstat_noise.wav');
[y5,Fs5]=audioread('Speech_shaped_noise.wav');

w1=[conv(y1,h_target(1,:)),conv(y1,h_target(2,:)),conv(y1,h_target(3,:)),conv(y1,h_target(4,:))];
w2=[conv(y2,h_inter1(1,:)),conv(y2,h_inter1(2,:)),conv(y2,h_inter1(3,:)),conv(y2,h_inter1(4,:))];
w3=[conv(y3,h_inter2(1,:)),conv(y3,h_inter2(2,:)),conv(y3,h_inter1(2,:)),conv(y3,h_inter2(4,:))];
w4=[conv(y4,h_inter3(1,:)),conv(y4,h_inter3(2,:)),conv(y4,h_inter3(3,:)),conv(y4,h_inter3(4,:))];
w5=[conv(y5,h_inter4(1,:)),conv(y5,h_inter4(2,:)),conv(y5,h_inter4(3,:)),conv(y5,h_inter4(4,:))];
a=size(w5,1);
w10=zeros(a-size(w1,1),4);
w20=zeros(a-size(w2,1),4);
w30=zeros(a-size(w3,1),4);
w40=zeros(a-size(w4,1),4);
w50=zeros(a-size(w5,1),4);
S1=[w1 ;w10];
S2=[w2 ;w20];
S3=[w3 ;w30];
S4=[w4 ;w40];
S5=[w5 ;w50];
S=S1+S2+S3+S4+S5;
sound(S(:,1),Fs1);

