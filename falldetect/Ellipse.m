for i=1:225
   s= regionprops(fg_smooth{i}, 'centroid','Orientation','Eccentricity');
   [x,y]=size(s);
   if(x==0 && y==1)
      rh(i)=NaN;
      th(i)=NaN;
      cent(i)=NaN;
   else    
   rh(i)=s(x,y).Eccentricity;
   th(i)=s(x,y).Orientation.*pi./180;
   cent(i,1)=s(x,y).Centroid(1);
   cent(i,2)=s(x,y).Centroid(2);
   end
end