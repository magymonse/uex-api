class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :current_agreement, :contact_name, :contact_email, :contact_phonenumber
end
