% show all images in DIFF2FFE
% Anatomical, mFFE MASK, mFFE GM (red), mFFE WM (blue)
% DTI: b0, FA (0 1), MD (0 to 3), RD (0 to 1), AD (0 to 4)
% NODDI: FICVF (0 to .7), FISO (0 to .6), ODI (0 to .25)
% SMT: extramd (extraneurite mean diffusivity 0 to 3), extratrans (extra transverse diffusivity .75 to 1.75), intra (intraneurite volume fraction, 0 to .7), diff
% (intrinsic diffusiviity 1 to 3.2)

clear; clc; close all;
addpath(genpath('/Volumes/schillkg/MATLAB/NIFTI_20130306/'))
addpath(genpath('/Volumes/schillkg/MATLAB/programs/'))

mkdir('FIGS')

%% Anatomical, mFFE MASK, mFFE GM (red), mFFE WM (blue)

a = load_untouch_nii('DIFF2FFE/mFFE_IMG.nii');
a = a.img;
A = imrotate(a,90);

figure; imshow(mat2gray(A));
print_current_figure(400,'FIGS/mFFE')
close all;

b = load_untouch_nii('DIFF2FFE/mFFE_MASK.nii');
b = b.img;
b = imrotate(b,90); 
b = logical(b);
B = imoverlay_color(A,b,[1 0 0]);

figure; imshow(B);
print_current_figure(400,'FIGS/mFFE_MASK')
close all;

c = load_untouch_nii('DIFF2FFE/mFFE_GM.nii');
c = c.img;
c = imrotate(c,90); 
c = logical(c);
C = imoverlay_color(A,c,[0 1 0]);

figure; imshow(C);
print_current_figure(400,'FIGS/mFFE_GM')
close all;

d = load_untouch_nii('DIFF2FFE/mFFE_WM.nii');
d = d.img;
d = imrotate(d,90); 
d = logical(d);
D = imoverlay_color(A,d,[0 0 1]);

figure; imshow(D);
print_current_figure(400,'FIGS/mFFE_WM')
close all;

% figure; set(gcf, 'units','normalized','outerposition',[0.05 0.05 .9 .9]);
% subplot(4,5,1); imagesc(A); colormap gray; axis equal; axis tight; axis off; title('ANATOMICAL')
% subplot(4,5,2); imagesc(B); colormap gray; axis equal; axis tight; axis off; title('MASK')
% subplot(4,5,3); imagesc(C); colormap gray; axis equal; axis tight; axis off; title('GM')
% subplot(4,5,4); imagesc(D); colormap gray; axis equal; axis tight; axis off; title('WM')


%% DTI: b0, FA (0 1), MD (0 to 3), RD (0 to 1), AD (0 to 4)

e = load_untouch_nii('DIFF2FFE/b02mFFE.nii');
e = e.img;
E = imrotate(e,90); 

figure; imshow(mat2gray(E));
print_current_figure(400,'FIGS/b02mFFE')
close all;

f = load_untouch_nii('DIFF2FFE/fa2mFFE.nii');
f = f.img;
F = imrotate(f,90); 
% 
% figure; imshow(mat2gray(F)); colorbar
% print_current_figure(400,'FIGS/dti_fa2mFFE')
% close all;
figure; imagesc(F,[0 1]); colormap gray; axis equal; axis tight; axis off; colorbar;
print_current_figure(400,'FIGS/dti_fa2mFFE')
close all;

%subplot(4,5,7); imagesc(F,[0 1]); colormap gray; axis equal; axis tight; axis off; title('FA'); colorbar

g = load_untouch_nii('DIFF2FFE/md2mFFE.nii');
g = g.img;
G = imrotate(g,90); 

figure; imagesc(G,[0 2E-9]); colormap gray; axis equal; axis tight; axis off; colorbar;
print_current_figure(400,'FIGS/dti_md2mFFE')
close all;

h = load_untouch_nii('DIFF2FFE/rd2mFFE.nii');
h = h.img;
H = imrotate(h,90);
temp = H>1e-10;

figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(H,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 1E-9]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/dti_rd2mFFE')
close all;

% ax1 = subplot(4,5,9); imagesc(A); colormap(ax1,'gray');
% ax2 = subplot(4,5,9); imagesc(H,'alphadata',temp); colormap(ax2,'jet');
% caxis(ax2,[min(nonzeros(H)) max(nonzeros(H))]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;

i = load_untouch_nii('DIFF2FFE/ad2mFFE.nii');
i = i.img;
I = imrotate(i,90);
temp = I>1e-10;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(I,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 4E-9]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/dti_ad2mFFE')
close all;

%% NODDI: FICVF (0 to .7), FISO (0 to .6), ODI (0 to .25)

j = load_untouch_nii('DIFF2FFE/NODDI__ficvf2mFFE.nii');
j = j.img;
J = imrotate(j,90);
temp = J>0.01;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(J,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 .7]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/noddi_ficvf2mFFE')
close all;

k = load_untouch_nii('DIFF2FFE/NODDI__fiso2mFFE.nii');
k = k.img;
K = imrotate(k,90);
temp = K>0.01;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(K,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 .6]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/noddi_fiso2mFFE')
close all;

l = load_untouch_nii('DIFF2FFE/NODDI__odi2mFFE.nii');
l = l.img;
L = imrotate(l,90);
temp = L>0.01;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(L,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 .25]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/noddi_odi2mFFE')
close all;

%% SMT
% extramd (extraneurite mean diffusivity 0 to 3), 
% extratrans (extra transverse diffusivity .75 to 1.75), 
% intra (intraneurite volume fraction, 0 to .7), 
% diff(intrinsic diffusiviity 1 to 3.2)

m = load_untouch_nii('DIFF2FFE/output_extramd2mFFE.nii');
m = m.img;
M = imrotate(m,90);
temp = M>0.0001;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(M,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 3E-3]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/smt_extramd2mFFE')
close all;

n = load_untouch_nii('DIFF2FFE/output_extratrans2mFFE.nii');
n = n.img;
N = imrotate(n,90);
temp = N>0.0001;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(N,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[.75E-3 1.75E-3]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/smt_extratrans2mFFE')
close all;

o = load_untouch_nii('DIFF2FFE/output_intra2mFFE.nii');
o = o.img;
O = imrotate(o,90);
temp = O>0.01;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(O,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[0 0.7]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/smt_intra2mFFE')
close all;

p = load_untouch_nii('DIFF2FFE/output_diff2mFFE.nii');
p = p.img;
P = imrotate(p,90);
temp = P>0.0001;
figure; ax1 = axes; imagesc(A); axis off; axis tight; axis equal; colormap(ax1,'gray'); ax2 = axes;
imagesc(P,'alphadata',temp); axis off; axis tight; axis equal; colormap(ax2,'jet');
caxis(ax2,[1E-3 3.2E-3]); ax2.Visible = 'off'; linkprop([ax1 ax2],'Position'); colorbar;
print_current_figure(400,'FIGS/smt_diff2mFFE')
close all;





































