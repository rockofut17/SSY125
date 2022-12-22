function full_message = Encoder(msg,type)
% This function encodes a bit message using convolutional encoder.
% It takes type of encoder and message to encode as argument.
% Note on generator Matrix, they are ordered in decending order
% that is starting on highest polynomial to lowest
% Returns: Encoded message
switch type
    case 'eps1'
        G1 = [1 1 1];
        G2 = [1 0 1]; 
    case 'eps2'
        G1 = [1 1 1 0 1];
        G2 = [0 1 1 0 1];
    case 'eps3'
        G1 = [1 1 0 0 1];
        G2 = [1 1 0 1 1];
end
% Encode the message using the conv function
        encoded_msg1 = mod(conv(msg,G1),2);
        encoded_msg2 = mod(conv(msg,G2),2);
        full_message = [encoded_msg1(1:end-length(G1)+1) ; encoded_msg2(1:end-length(G2)+1)];
        full_message = reshape(full_message,1,[]);
       

end