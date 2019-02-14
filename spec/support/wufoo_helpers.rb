# frozen_string_literal: true
def stub_wufoo
  allow(Form).to receive(:update_forms)
  allow_any_instance_of(Form).to receive_messages(
    wufoo_form: nil,
    wufoo_last_updated: 1.day.ago,
    fields: STUB_FIELDS,
    details: STUB_DETAILS,
    entries: STUB_ENTRIES,
    wufoo_entry: STUB_ENTRY
  )
end

STUB_FIELDS =
  [
    { 'Title'=>'Entry Id', 'Type'=>'text', 'ID'=>'EntryId' },
    { 'Title'        => 'Name',
      'Instructions' => '',
      'IsRequired'   => '0',
      'ClassNames'   => '',
      'DefaultVal'   => '',
      'Page'         => '1',
      'SubFields'    => [{ 'DefaultVal'=>'', 'ID'=>'Field964', 'Label'=>'First' }, { 'DefaultVal'=>'', 'ID'=>'Field965', 'Label'=>'Last' }],
      'Type'         => 'shortname',
      'ID'           => 'Field964' },
    { 'Title'=>'Email', 'Instructions'=>'', 'IsRequired'=>'0', 'ClassNames'=>'', 'DefaultVal'=>'', 'Page'=>'1', 'Type'=>'email', 'ID'=>'Field966' },
    { 'Title'=>'Phone Number', 'Instructions'=>'', 'IsRequired'=>'0', 'ClassNames'=>'', 'DefaultVal'=>'', 'Page'=>'1', 'Type'=>'phone', 'ID'=>'Field967' },
    { 'Title'        => "Are you a Veteran, Veteran's family member, or Veteran's caretaker?",
      'Instructions' => '',
      'IsRequired'   => '0',
      'ClassNames'   => '',
      'DefaultVal'   => '0',
      'Page'         => '1',
      'SubFields'    =>
                        [{ 'DefaultVal'=>'0', 'ID'=>'Field974', 'Label'=>'Veteran' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field975', 'Label'=>"Veteran's family member" },
                         { 'DefaultVal'=>'0', 'ID'=>'Field976', 'Label'=>"Veteran's caretaker" }],
      'Type'         => 'checkbox',
      'ID'           => 'Field974' },
    { 'Title'        => 'Gender',
      'Instructions' => '',
      'IsRequired'   => '0',
      'ClassNames'   => '',
      'DefaultVal'   => '0',
      'Page'         => '1',
      'SubFields'    =>
                        [{ 'DefaultVal'=>'0', 'ID'=>'Field540', 'Label'=>'Female' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field541', 'Label'=>'Male' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field542', 'Label'=>'Transgender' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field543', 'Label'=>'Other' }],
      'Type'         => 'checkbox',
      'ID'           => 'Field540' },
    { 'Title'        => 'Race or ethnic background',
      'Instructions' => '',
      'IsRequired'   => '0',
      'ClassNames'   => '',
      'DefaultVal'   => '0',
      'Page'         => '1',
      'SubFields'    =>
                        [{ 'DefaultVal'=>'0', 'ID'=>'Field646', 'Label'=>'American Indian or Alaska Native' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field647', 'Label'=>'Asian' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field648', 'Label'=>'Black or African American' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field649', 'Label'=>'Native Hawaiian or Other Pacific Islander' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field650', 'Label'=>'White or Caucasian' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field651', 'Label'=>'Hispanic or Latino' },
                         { 'DefaultVal'=>'0', 'ID'=>'Field652', 'Label'=>'Other' }],
      'Type'         => 'checkbox',
      'ID'           => 'Field646' },
    { 'Title'         => 'Age',
      'Instructions'  => '',
      'IsRequired'    => '0',
      'ClassNames'    => '',
      'DefaultVal'    => '',
      'Page'          => '1',
      'Choices'       => [{ 'Label'=>'18 - 24' }, { 'Label'=>'25 - 34' }, { 'Label'=>'35 - 44' }, { 'Label'=>'45 - 54' }, { 'Label'=>'55 - 64' }, { 'Label'=>'65 - 74' }, { 'Label'=>'75 or older' }],
      'Type'          => 'radio',
      'ID'            => 'Field972',
      'HasOtherField' => false },
    { 'Title'         => 'Education',
      'Instructions'  => '',
      'IsRequired'    => '0',
      'ClassNames'    => '',
      'DefaultVal'    => '',
      'Page'          => '1',
      'Choices'       =>
                         [{ 'Label'=>'Some high school (no diploma)' },
                          { 'Label'=>'High school diploma or equivalent (for ex: GED)' },
                          { 'Label'=>'Associate’s degree / trade certificate / vocational training' },
                          { 'Label'=>'Some college (no degree)' },
                          { 'Label'=>"Bachelor's degree" },
                          { 'Label'=>"Master's degree" },
                          { 'Label'=>'Doctorate degree' },
                          { 'Label'=>'Other' }],
      'Type'          => 'radio',
      'ID'            => 'Field533',
      'HasOtherField' => true },
    { 'Title'=>'Date Created', 'Type'=>'date', 'ID'=>'DateCreated' },
    { 'Title'=>'Created By', 'Type'=>'text', 'ID'=>'CreatedBy' },
    { 'Title'=>'Last Updated', 'Type'=>'date', 'ID'=>'LastUpdated' },
    { 'Title'=>'Updated By', 'Type'=>'text', 'ID'=>'UpdatedBy' }
  ].freeze

STUB_DETAILS =
  {
    'Name'             => '[DEV] Submission testing form',
    'Description'      => nil,
    'RedirectMessage'  => "Thanks! We'll be in touch when we have good feedback opportunities coming up.",
    'Url'              => 'dev-submission-testing-form',
    'Email'            => '',
    'IsPublic'         => '1',
    'Language'         => 'english',
    'StartDate'        => '2000-01-01 12:00:00',
    'EndDate'          => '2030-01-01 12:00:00',
    'EntryLimit'       => '0',
    'DateCreated'      => '2017-01-12 10:26:58',
    'DateUpdated'      => '2017-04-04 08:33:20',
    'Hash'             => 'z4iqdr01m1qhdu',

    'LinkFields'       => 'https://adhocteamus.wufoo.com/api/v3/forms/z4iqdr01m1qhdu/fields.json',
    'LinkEntries'      => 'https://adhocteamus.wufoo.com/api/v3/forms/z4iqdr01m1qhdu/entries.json',
    'LinkEntriesCount' => 'https://adhocteamus.wufoo.com/api/v3/forms/z4iqdr01m1qhdu/entries/count.json'
  }.freeze

STUB_ENTRIES =
  [{ 'EntryId'     => '2',
     'Field964'    => 'Bob',
     'Field965'    => 'Marley',
     'Field966'    => 'bobmarley@bobmarley.em',
     'Field967'    => '',
     'Field974'    => 'Veteran',

     'Field975'    => '',
     'Field976'    => '',
     'Field540'    => '',
     'Field541'    => 'Male',
     'Field542'    => '',
     'Field543'    => '',
     'Field646'    => '',
     'Field647'    => '',
     'Field648'    => 'Black or African American',
     'Field649'    => '',
     'Field650'    => '',
     'Field651'    => '',
     'Field652'    => '',
     'Field972'    => '65 - 74',
     'Field533'    => "Bachelor's degree",
     'DateCreated' => '2017-04-04 11:47:23',
     'CreatedBy'   => 'Nick',
     'DateUpdated' => '',
     'UpdatedBy'   => nil }].freeze

STUB_ENTRY =
  { 'EntryId'     => '2',
    'Field964'    => 'Bob',
    'Field965'    => 'Marley',
    'Field966'    => 'bobmarley@bobmarley.em',
    'Field974'    => 'Veteran',
    'Field541'    => 'Male',
    'Field648'    => 'Black or African American',
    'Field972'    => '65 - 74',
    'Field533'    => "Bachelor's degree",
    'DateCreated' => '2017-04-04 11:47:23',
    'CreatedBy'   => 'Nick' }.freeze

STUB_WUFOO_SIGNUP_PARAMS =
  {
    'FieldStructure'=>'{"Fields":[{"Title":"Name","Instructions":"","IsRequired":"1","ClassNames":"","DefaultVal":"","Page":"1","SubFields":[{"DefaultVal":"","ID":"Field1","Label":"First"},{"DefaultVal":"","ID":"Field2","Label":"Last"}],"Type":"shortname","ID":"Field1"},{"Title":"Email","Instructions":"","IsRequired":"0","ClassNames":"","DefaultVal":"","Page":"1","Type":"email","ID":"Field4"},{"Title":"Phone number","Instructions":"","IsRequired":"0","ClassNames":"","DefaultVal":"","Page":"1","Type":"text","ID":"Field1418"},{"Title":"Best way for us to contact you (select one)","Instructions":"","IsRequired":"1","ClassNames":"","DefaultVal":"","Page":"1","Choices":[{"Label":"Email"},{"Label":"Phone call"},{"Label":"Text message"}],"Type":"radio","ID":"Field212","HasOtherField":false},{"Title":"Do you want us to contact you to participate in other kinds of website feedback sessions, outside of this VA feedback project?","Instructions":"","IsRequired":"1","ClassNames":"","DefaultVal":"","Page":"1","Choices":[{"Label":"Yes"},{"Label":"No"}],"Type":"radio","ID":"Field1420","HasOtherField":false}]}', 'FormStructure'=>'{"Name":"Feedback Session Sign Up","Description":null,"RedirectMessage":"Great! Thanks for signing up, we will be in touch!","Url":"feedback-session-sign-up","Email":null,"IsPublic":"1","Language":"english","StartDate":"2000-01-01 12:00:00","EndDate":"2030-01-01 12:00:00","EntryLimit":"0","DateCreated":"2017-01-04 14:40:23","DateUpdated":"2017-03-27 10:47:48","Hash":"x1hf8igs0ukwq5y"}', 'Field1'=>'Bob', 'Field2'=>'Tester', 'Field4'=>'bobtester@yahoo.com', 'Field1418'=>'3189885295', 'Field212'=>'Email', 'Field1420'=>'Yes', 'Entsource'=>'', 'CreatedBy'=>'public', 'DateCreated'=>'2017-04-06 10:56:29', 'EntryId'=>'76', 'IP'=>'97.78.75.110', 'HandshakeKey'=>'cohorts-wufoo-dev-vets-signup'
  }.freeze

STUB_WUFOO_SUBMISSION_PARAMS =
  {
    'FieldStructure'=>"{\"Fields\":[{\"Title\":\"Name\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"\",\"ID\":\"Field964\",\"Label\":\"First\"},{\"DefaultVal\":\"\",\"ID\":\"Field965\",\"Label\":\"Last\"}],\"Type\":\"shortname\",\"ID\":\"Field964\"},{\"Title\":\"Email\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Type\":\"email\",\"ID\":\"Field966\"},{\"Title\":\"Phone Number\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Type\":\"phone\",\"ID\":\"Field967\"},{\"Title\":\"Are you a Veteran, Veteran's family member, or Veteran's caretaker?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field974\",\"Label\":\"Veteran\"},{\"DefaultVal\":\"0\",\"ID\":\"Field975\",\"Label\":\"Veteran's family member\"},{\"DefaultVal\":\"0\",\"ID\":\"Field976\",\"Label\":\"Veteran's caretaker\"}],\"Type\":\"checkbox\",\"ID\":\"Field974\"},{\"Title\":\"Gender\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field540\",\"Label\":\"Female\"},{\"DefaultVal\":\"0\",\"ID\":\"Field541\",\"Label\":\"Male\"},{\"DefaultVal\":\"0\",\"ID\":\"Field542\",\"Label\":\"Transgender\"},{\"DefaultVal\":\"0\",\"ID\":\"Field543\",\"Label\":\"Other\"}],\"Type\":\"checkbox\",\"ID\":\"Field540\"},{\"Title\":\"Race or ethnic background\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field646\",\"Label\":\"American Indian or Alaska Native\"},{\"DefaultVal\":\"0\",\"ID\":\"Field647\",\"Label\":\"Asian\"},{\"DefaultVal\":\"0\",\"ID\":\"Field648\",\"Label\":\"Black or African American\"},{\"DefaultVal\":\"0\",\"ID\":\"Field649\",\"Label\":\"Native Hawaiian or Other Pacific Islander\"},{\"DefaultVal\":\"0\",\"ID\":\"Field650\",\"Label\":\"White or Caucasian\"},{\"DefaultVal\":\"0\",\"ID\":\"Field651\",\"Label\":\"Hispanic or Latino\"},{\"DefaultVal\":\"0\",\"ID\":\"Field652\",\"Label\":\"Other\"}],\"Type\":\"checkbox\",\"ID\":\"Field646\"},{\"Title\":\"Age\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field972\",\"HasOtherField\":false},{\"Title\":\"Education\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field533\",\"HasOtherField\":true},{\"Title\":\"Employment status and profession\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field857\",\"HasOtherField\":true},{\"Title\":\"Which part of the country do you live in?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field853\",\"HasOtherField\":false},{\"Title\":\"Do you live in an urban, suburban, or rural area?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field855\",\"HasOtherField\":false},{\"Title\":\"Are you or have you ever been a VA employee or a Veteran Service Officer (VSO)?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field113\",\"HasOtherField\":false},{\"Title\":\"Are you comfortable looking at a website in English, and telling us your opinions in English?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field751\",\"HasOtherField\":true},{\"Title\":\"How did you hear about the opportunity to participate in VA website research?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Type\":\"text\",\"ID\":\"Field102\"},{\"Title\":\"Which branch of the military are\\/were you in?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field104\",\"HasOtherField\":false},{\"Title\":\"Around which year did you join the service?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"YYYY\",\"Page\":\"1\",\"Type\":\"number\",\"ID\":\"Field106\"},{\"Title\":\"Are you still active duty?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field111\",\"HasOtherField\":false},{\"Title\":\"Around which year did you get out of the service?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"YYYY\",\"Page\":\"1\",\"Type\":\"number\",\"ID\":\"Field107\"},{\"Title\":\"Anything else you'd like to share about your time serving?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Type\":\"textarea\",\"ID\":\"Field109\"},{\"Title\":\"Which health-related VA benefits or services are you currently exploring, or have you used in the past?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field217\",\"Label\":\"None\"},{\"DefaultVal\":\"0\",\"ID\":\"Field218\",\"Label\":\"Dental Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field225\",\"Label\":\"Vision Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field226\",\"Label\":\"Mental Health Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field227\",\"Label\":\"Women's Health Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field230\",\"Label\":\"My HealtheVet\"},{\"DefaultVal\":\"0\",\"ID\":\"Field231\",\"Label\":\"eBenefits\"},{\"DefaultVal\":\"0\",\"ID\":\"Field233\",\"Label\":\"Secure messaging\"},{\"DefaultVal\":\"0\",\"ID\":\"Field234\",\"Label\":\"Online Rx Refill\"},{\"DefaultVal\":\"0\",\"ID\":\"Field235\",\"Label\":\"Downloading medical records\"},{\"DefaultVal\":\"0\",\"ID\":\"Field219\",\"Label\":\"Emergency Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field236\",\"Label\":\"Hospitals\"},{\"DefaultVal\":\"0\",\"ID\":\"Field237\",\"Label\":\"Primary Care\"},{\"DefaultVal\":\"0\",\"ID\":\"Field238\",\"Label\":\"Clinics\"},{\"DefaultVal\":\"0\",\"ID\":\"Field224\",\"Label\":\"Other\"}],\"Type\":\"checkbox\",\"ID\":\"Field217\"},{\"Title\":\"Which other VA benefits or services are you currently exploring, or have you used in the past?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field861\",\"Label\":\"None\"},{\"DefaultVal\":\"0\",\"ID\":\"Field871\",\"Label\":\"Education Benefits\"},{\"DefaultVal\":\"0\",\"ID\":\"Field862\",\"Label\":\"GI Bill\"},{\"DefaultVal\":\"0\",\"ID\":\"Field863\",\"Label\":\"Vocational Rehabilitation\"},{\"DefaultVal\":\"0\",\"ID\":\"Field864\",\"Label\":\"Career Services\"},{\"DefaultVal\":\"0\",\"ID\":\"Field865\",\"Label\":\"Housing Benefits\"},{\"DefaultVal\":\"0\",\"ID\":\"Field866\",\"Label\":\"Homelessness Services\"},{\"DefaultVal\":\"0\",\"ID\":\"Field867\",\"Label\":\"Disability Services\"},{\"DefaultVal\":\"0\",\"ID\":\"Field868\",\"Label\":\"Pension Services\"},{\"DefaultVal\":\"0\",\"ID\":\"Field869\",\"Label\":\"Insurance\"},{\"DefaultVal\":\"0\",\"ID\":\"Field872\",\"Label\":\"National Cemetery Association Services\"},{\"DefaultVal\":\"0\",\"ID\":\"Field870\",\"Label\":\"Other\"}],\"Type\":\"checkbox\",\"ID\":\"Field861\"},{\"Title\":\"How often do you use VA benefits and services?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field320\",\"HasOtherField\":false},{\"Title\":\"How often do you go online to access these VA benefits and services?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field322\",\"HasOtherField\":false},{\"Title\":\"How often do you go online in general?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field859\",\"HasOtherField\":false},{\"Title\":\"What kinds of activities do you do online?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"0\",\"Page\":\"1\",\"SubFields\":[{\"DefaultVal\":\"0\",\"ID\":\"Field325\",\"Label\":\"I don't use the internet much \\/ at all\"},{\"DefaultVal\":\"0\",\"ID\":\"Field326\",\"Label\":\"Social Media\"},{\"DefaultVal\":\"0\",\"ID\":\"Field327\",\"Label\":\"Email\"},{\"DefaultVal\":\"0\",\"ID\":\"Field328\",\"Label\":\"Entertainment \\/ TV\"},{\"DefaultVal\":\"0\",\"ID\":\"Field329\",\"Label\":\"Research\"},{\"DefaultVal\":\"0\",\"ID\":\"Field330\",\"Label\":\"Banking\"},{\"DefaultVal\":\"0\",\"ID\":\"Field331\",\"Label\":\"Other\"}],\"Type\":\"checkbox\",\"ID\":\"Field325\"},{\"Title\":\"What device do you use the most to go online?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field970\",\"HasOtherField\":true},{\"Title\":\"What device do you use the second-most to go online?\",\"Instructions\":\"\",\"IsRequired\":\"0\",\"ClassNames\":\"\",\"DefaultVal\":\"\",\"Page\":\"1\",\"Choices\":[{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null},{\"Label\":null}],\"Type\":\"radio\",\"ID\":\"Field969\",\"HasOtherField\":true}]}", 'FormStructure'=>"{\"Name\":\"Vets.gov Participant Background Info\",\"Description\":\"Please enter some background information about yourself, so we can match you up with great feedback session opportunities.\",\"RedirectMessage\":\"Thanks! We'll be in touch when we have good feedback opportunities coming up.\",\"Url\":\"vetsgov-participant-background-info\",\"Email\":null,\"IsPublic\":\"1\",\"Language\":\"english\",\"StartDate\":\"2000-01-01 12:00:00\",\"EndDate\":\"2030-01-01 12:00:00\",\"EntryLimit\":\"0\",\"DateCreated\":\"2017-01-12 10:26:58\",\"DateUpdated\":\"2017-03-28 13:13:37\",\"Hash\":\"k12z8n2o1gmaduv\"}", 'Field964'=>'Brian', 'Field965'=>'Fentan', 'Field966'=>'fake.brian.fentan@yahoo.com', 'Field967'=>'9224693733', 'Field974'=>'Veteran', 'Field541'=>'Male', 'Field648'=>'Black or African American', 'Field972'=>'35 - 44', 'Field533'=>'Some college (no degree)', 'Field857'=>'Construction inspector', 'Field853'=>'Northeast / Mid-Atlantic', 'Field855'=>'Urban', 'Field113'=>'No', 'Field751'=>'Yes', 'Field102'=>"Doesn't remember", 'Field104'=>'Marine Corps', 'Field106'=>'1993', 'Field111'=>'No', 'Field107'=>'1995', 'Field109'=>'', 'Field236'=>'Hospitals', 'Field865'=>'Housing Benefits', 'Field962'=>'', 'Field320'=>'About once a year', 'Field322'=>'About once a year', 'Field859'=>'Daily', 'Field327'=>'Email', 'Field329'=>'Research', 'Field426'=>'', 'Field970'=>'Tablet', 'Field969'=>'Cell phone', 'Field975'=>'', 'Field976'=>'', 'Field540'=>'', 'Field542'=>'', 'Field543'=>'', 'Field646'=>'', 'Field647'=>'', 'Field649'=>'', 'Field650'=>'', 'Field651'=>'', 'Field652'=>'', 'Field217'=>'', 'Field218'=>'', 'Field225'=>'', 'Field226'=>'', 'Field227'=>'', 'Field230'=>'', 'Field231'=>'', 'Field233'=>'', 'Field234'=>'', 'Field235'=>'', 'Field219'=>'', 'Field237'=>'', 'Field238'=>'', 'Field224'=>'', 'Field861'=>'', 'Field871'=>'', 'Field862'=>'', 'Field863'=>'', 'Field864'=>'', 'Field866'=>'', 'Field867'=>'', 'Field868'=>'', 'Field869'=>'', 'Field872'=>'', 'Field870'=>'', 'Field325'=>'', 'Field326'=>'', 'Field328'=>'', 'Field330'=>'', 'Field331'=>'', 'CreatedBy'=>'public', 'DateCreated'=>'2017-04-04 15:35:30', 'EntryId'=>'51', 'IP'=>'70.106.193.241', 'HandshakeKey'=>'cohorts-wufoo-dev-submission'
  }.freeze
