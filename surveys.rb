#Provides the methods to access the Rails application database to conduct the survey

methods_for :dialplan do

  #Method to create files themselves, takes the texts, creates the file and returns the filename
  def surveys_create_file(text)

    case COMPONENTS.surveys[:engine]
    #Cepstral speech engine, see http://www.cepstral.com, as it requires a license
    when "cepstral"
      filename = COMPONENTS.surveys[:sound_dir] + new_guid + ".wav"
      system("swift -o #{filename} -p audio/channels=1,audio/sampling-rate=8000 '#{text}'")
    #Festival OSS speech engine
    #on CentOS v5.0+ simply do a yum install festival
    when "festival"
      filename = COMPONENTS.surveys[:sound_dir] + new_guid + ".ulaw"
      system("echo #{text} | text2wave -o #{filename} -otype ulaw")
    #Currently uses the built in OSX TTS engine 'say' which is part of PlainTalk 
    #http://en.wikipedia.org/wiki/Plaintalk
    when "osx_say"
      filename = COMPONENTS.surveys[:sound_dir] + new_guid
      system("say -v #{COMPONENTS.surveys[:voice]} -o #{filename}.aiff #{text}")
      system("sox #{filename}.aiff -r 8000 -t ul #{filename}.ulaw")
    end
    
    return filename
  end
  
  #A method to convert the response ranges from the database to a Range
  def to_range(str)
    case str.count('.')
      when 2
        elements = str.split('..')
        return Range.new(elements[0].to_i, elements[1].to_i)
      when 3
        elements = str.split('...')
        return Range.new(elements[0].to_i, elements[1].to_i-1)
      else
        raise ArgumentError.new("Couldn't convert to Range: #{str}")
      end
  end
    
  #Takes the company name and builds a single audiofile welcome message
  def surveys_build_welcome(company_name)
    return surveys_create_file("Welcome to the #{company_name} survey service, we appreciate you taking the time to provide your feedback. " +
                                "Please answer the following questions with your touch tone keypad.")
  end
  
  #Takes the company name and builds a single audiofile thank you message
  def surveys_build_thankyou(company_name)
    return surveys_create_file("Thank again for answring the #{company_name} survey service, your feedback is appreciated. Goodbye.")
  end
  
  #Takes the survey name and builds an array of hashes of files asking for the input
  def surveys_build_questions(survey_name)
    survey = Survey.find_by_name(survey_name)
    questions = survey.questions(:order => 'order')
    
    questions_to_ask = Array.new
    questions.each do |question|      
      questions_to_ask << { :name => question.name, 
                            :question => question.question, 
                            :valid_responses => question.valid_responses, 
                            :audio_file => surveys_create_file(question.question),
                            :database_record => question }
    end
    return questions_to_ask
  end
  
  #The menu that will actually ask all of the questions
  def surveys_ask_questions(questions_to_ask, tag)
    questions_to_ask.each do |question|
      response, cnt = 0, 0
      while cnt < COMPONENTS.surveys[:retries]
        response = input 1,
                         :timeout => 5.seconds,
                         :play => question[:audio_file]
        break if to_range(question[:valid_responses]) === response.to_i
        play surveys_create_file("Invalid selection, please try again")
        cnt += 1
      end

      if to_range(question[:valid_responses]) === response.to_i
        surveys_insert_response(question, response, tag)
      else
        play 'goodbye'
        hangup
      end
    end
  end
  
  #Lets log the repsonses to the related question in the responses table
  def surveys_insert_response(question, response, tag)
    response_entry = Response.new 
    response_entry.question_id = question[:database_record].id
    response_entry.callerid = callerid
    response_entry.guid = tag
    response_entry.response = response
    response_entry.save
  end 
   
end
