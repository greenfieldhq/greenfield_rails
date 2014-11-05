class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :first_name, :last_name, :email
end
