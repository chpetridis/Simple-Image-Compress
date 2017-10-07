function ImageCompression(Q)
	
	%{ 	Q is a given quantum table
		e.g.
			16 11 10 16 24 40 51 61
			12 12 14 19 26 58 60 55
			14 13 16 24 40 57 69 56
			14 17 22 29 51 87 80 62
			18 22 37 56 68 109 103 77
			24 35 55 64 81 104 113 92
			49 64 78 87 103 121 120 101
			72 92 95 98 112 100 103 99
	%}

    original_image=imread('cameraman.tif');
    colormap(gray);
    disp('Original Image entropy: ');disp(entropy(original_image));
    
    splitvector=repelem(8,32);
    f=mat2cell(original_image,splitvector,splitvector);
    counter_x=1;counter_y=1;
    decompressed_image=zeros(256);compressed_image=zeros(256);
    for i=1:1:1024
    	% ---------- COMPRESSION PHASE ------------ 
        F=dct2(cell2mat(f(i)));
        for k=1:1:8
            for m=1:1:8
                F(k,m)=round(F(k,m)/Q(k,m));
            end
        end
        a=counter_x;b=counter_y;
        for k=1:1:8
            for m=1:1:8
                compressed_image(a,b)=F(k,m);
                b=b+1;
            end
           b=counter_y;
           a=a+1;
        end
	% ----------- DECOMPRESSION PHASE -------------
          for k=1:1:8
            for m=1:1:8
                F(k,m)=F(k,m)*Q(k,m);
            end
          end
          F=idct2(F);
          a=counter_x;b=counter_y;
          for k=1:1:8
             for m=1:1:8
                decompressed_image(a,b)=F(k,m);
                b=b+1;
             end
             b=counter_y;
             a=a+1;
          end
          counter_x=counter_x+8;
          if counter_x>256
            counter_x=1;
            counter_y=counter_y+8;
          end   
    end
     p=min(compressed_image);
     disp('Changed entropy: ');disp(entropy(uint8(compressed_image + abs(p(1)))));
     decompressed_image=uint8(decompressed_image);
     imagesc(decompressed_image);
     disp('PSNR: ');
     disp(psnr(original_image,decompressed_image));
end
