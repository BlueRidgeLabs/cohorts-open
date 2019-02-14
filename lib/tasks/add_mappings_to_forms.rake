namespace :add_mappings_to_forms do
  desc 'Add mappings to existing wufoo forms'
    task :update => :environment do
      Form.find_by(hash_id: 'z15g6mjw0nvi2vu').update(mapping: {
        'Field1'=>'first_name',
        'Field2'=>'last_name',
        'Field4'=>'address_1',
        'Field5'=>'address_2',
        'Field6'=>'city',
        'Field7'=>'state',
        'Field8'=>'postal_code',
        'Field10'=>'email_address',
        'Field11'=>'phone_number',
        'Field12'=>'participation_type',
        'Field140'=>'primary_device_id',
        'Field24'=>'primary_device_description'
      })
      Form.find_by(hash_id: 'x1hf8igs0ukwq5y').update(mapping: {
        'Field1'=>'first_name',
        'Field2'=>'last_name',
        'Field1418'=>'phone_number',
        'Field4'=>'email_address',
        'Field212'=>'preferred_contact_method'
      })
      Form.find_by(hash_id: 'm583beg1n3fwlq').update(mapping: {
        'Field1'=>'first_name', 
        'Field2'=>'last_name', 
        'Field3'=>'email_address',
        'Field4'=>'phone_number', 
        'Field5'=>'preferred_contact_method'
      })
      Form.find_by(hash_id: 'q976bns0isnkx0').update(mapping: {
        'Field1'=>'first_name',
        'Field2'=>'last_name',
        'Field3'=>'email_address',
        'Field5'=>'phone_number'
      })
      Form.find_by(hash_id: 'qc4n60610rdvng').update(mapping: {
        'Field1'=>'first_name',
        'Field2'=>'last_name',
        'Field3'=>'email_address',
        'Field4'=>'phone_number',
        'Field114'=>'postal_code'
      })
    end
end
