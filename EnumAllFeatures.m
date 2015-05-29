function [ all_ftypes ] = EnumAllFeatures( W, H )
%ENUMALLFEATURES Summary of this function goes here
%   format of all_ftypes: [ type x y w h ]
%                           typ  x y w h ]
%                            .   . . . . ]
%                 row nf: [ type x y w h ]     nf x 5

i = 0;
all_ftypes = zeros(42984, 5);

%All features of type 1:
for h = 1:floor((H-1)/2)
    for w = 1:W-1
        for y = 2:H-2*h+1
            for x = 2:W-w+1
                i=i+1;
                all_ftypes(i,:) = [1 x y w h];
            end
        end
    end
end

%All features of type 2:
for w = 1:floor((W-1)/2)
    for h = 1:H-1
        for x = 2:W-2*w+1
            for y = 2:H-h+1
                i=i+1;
                all_ftypes(i,:) = [2 x y w h];
            end
        end
    end
end

%All features of type 3:
for w = 1:floor((W-1)/3)
    for h = 1:H-1
        for x = 2:W-3*w+1
            for y = 2:H-h+1
                i=i+1;
                all_ftypes(i,:) = [3 x y w h];
            end
        end
    end
end

%All features of type 4:
for w = 1:floor((W-1)/2)
    for h = 1:floor((H-1)/2)
        for x = 2:W-2*w+1
            for y = 2:H-2*h+1
                i=i+1;
                all_ftypes(i,:) = [4 x y w h];
            end
        end
    end
end

i

end

