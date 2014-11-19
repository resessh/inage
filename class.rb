class Inage

	def initialize
		@empty = parse(request)
	end

	def request
		crt0100_uri = URI.parse("http://www.e-license.jp/examples/servlet/Crt0100")
		crt0200_uri = URI.parse("http://www.e-license.jp/examples/servlet/Crt0200?sentakuButton=A&button=")

		post = {
			'seitoBangou' => INAGE_ID,
			'ansyouBangou' => INAGE_PASS,
			'navigation' => 'N',
			'abc' => 'P',
			'lmn' => 'inage'
		}
		
		postData = post.map do |param, value|
			"#{param}=#{value}"
		end.join('&')

		cookie = {}
		Net::HTTP.start(crt0100_uri.host, 80) do |http|
			res = http.post(crt0100_uri.path, postData)

			res.get_fields('Set-Cookie').each do |str|
				param, value = str[0...str.index(';')].split('=')
				cookie[param] = value
			end
		end

		cookie['myID'] = INAGE_ID
		cookie['myURL'] = 'http://www.e-license.jp/el/inage/login.html'
		cookie['mywbName'] = 'Netscape'
		cookie['myappVer'] = '5.0%20%28Macintosh%3B%20Intel%20Mac%20OS%20X%2010_9_5%29%20AppleWebKit/537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome/39.0.2171.42%20Safari/537.36'

		cookieData = cookie.map do |param, value|
			"#{param}=#{value}"
		end.join(';')

		Net::HTTP.start(crt0200_uri.host, 80) do |http|
			res = http.get(crt0200_uri.path + "?" + crt0200_uri.query, 'Cookie' => cookieData )
		end.body
	end

	def parse body
		utf_body = body.encode('utf-8', 'Shift_Jis')

		utf_body.scan('OK1.gif').length - 1
	end

	def get_empty
		@empty
	end
end

class Log

	def initialize
		@last_empty = read
	end

	def read
		File.read(LOG_PATH).split(',')[0].to_i
	end

	def get_last_empty
		@last_empty
	end

	def write new_empty
		File.write(LOG_PATH, "#{new_empty}, #{DateTime.now.to_s}\n#{open(LOG_PATH).read}")
	end
end