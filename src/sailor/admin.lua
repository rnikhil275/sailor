local M ={}
function M.gen()
	local code=[[--add one more opening bracket here

<?lua
local conf = require "conf.conf"
local access = require "sailor.access"
local session = require "sailor.session"

access.settings{default_password = conf.sailor.admin_password}

if next(page.POST) then
		local login, err = access.login('admin', page.POST.password)
		if login then
			?>
		
			<p>Login success. (it should redirect form here)</p>
			<a href="?r=/admin/conf"> Config editor</a><br>
			<a href="?r=autogen"> Autogen Fucntions</a>

			<?lua
			else ?>
				<p>Password error. Check config file</p>
				<?lua
		end
	end
?>
<?lua	
if access.is_guest() then ?>	
	<h2>Admin Center</h2>
	<p>Enter the password set in the config file</p>
<form method="post">
	<input type="password"  name="password"/>
	<input type="submit" />
</form>
<?lua
else ?>
		<button id='button'>Logout</button>

<?lua@client

function logout(access, page)
	window:alert('This code was written in Lua')
	print('yadsf')

end

local btn = window.document:getElementById('button')
btn.onclick = logout
?><?lua
 end ?>


	]]
	return code

end



return M