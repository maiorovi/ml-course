function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
% Setup some useful variables
m = size(X, 1);
L = 2;

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%transform y here
yMod = zeros(size(y,1),size(Theta2,1));
for j = 1:size(y, 1) 
  yMod(j, y(j)) = 1;
end

a1 = [ones(size(X, 1), 1) X];
% Theta1 25 x 401; a1 - 5000 % 401
a2 = sigmoid(Theta1*a1');

%�2 - 25 � 5000
a21 =  [ones(size(a2', 1), 1) a2'];
%size(a21);
% Theta2 10 x 26; a2 = 26 x 5000
%size(Theta2);
a3 = sigmoid(Theta2 * a21')';
%size(a3)
% a3 = 10 x 5000; a3' = 5000 x 10
cost = 0;
%size(y,1)
for i =1:size(a3,1)
  for k=1:size(yMod, 2)
   tmp = -yMod(i,k) * log(a3(i,k)) - (1 - yMod(i,k))*log(1 - a3(i,k));
   cost = cost + tmp;
  end
end

J = cost / m;

regularization = (sum((Theta1(:,2:end) .^ 2)(:)) + sum((Theta2(:,2:end) .^ 2)(:))) * (lambda / (2*m));
J = J + regularization;
% -------------------------------------------------------------

% =========================================================================
delta_f_1 = zeros(size(Theta2, 2) - 1, size(Theta1, 2)); % l = 1 m x 
delta_f_2 = zeros(size(Theta2, 1), size(Theta2, 2));
for i=1:m
  a_1 = [1,X(i,:)]; %a_1 = 1x401
  z_2 = Theta1 * a_1'; % Theta1(i) =  25 x 401; z = 25 x 1
  a_2 = [1,sigmoid(z_2)']'; % 25x1
  z_3 = Theta2 * a_2; % Theta2 = 10 x 26
  a_3 = sigmoid(z_3); % a_3 = 10 x 1
  delta_3 = a_3 - yMod(i,:)'; % delta3 = 10 x 1
  delta_2 = (Theta2(:,2:end)' * delta_3) .* sigmoidGradient(z_2); %delta = 25x1
  %Theta2' * delta_3 =  25 x 10 *  10 x 1 = 25_1 .* 25_1
  delta_f_1 = delta_f_1 + delta_2 * a_1; % delta_f_1 = 25x 1 * 1 x 401 = 25 x 401 
  %size(delta_f_1)
  delta_f_2 = delta_f_2 + delta_3 * (a_2)'; % delta_f_2 = 10 x 1 * 26x1 = 10 x 26
  % 10 x 1 * 25 x 1 = 10 x 25
end


for i= 1:size(Theta1,1)
  for j = 2:size(Theta1,2)
    delta_f_1(i,j) = delta_f_1(i,j) + lambda * Theta1(i,j);
  end
end

for i= 1:size(Theta2,1)
  for j = 2: size(Theta2, 2)
    delta_f_2(i,j) = delta_f_2(i,j) + lambda * Theta2(i,j);
  end
end

Theta1_grad=delta_f_1 ./ m;
Theta2_grad= delta_f_2 ./ m;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
