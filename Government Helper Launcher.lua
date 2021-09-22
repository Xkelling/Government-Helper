script_name    		('Government Helper')
script_properties	("work-in-pause")
script_author  		('Rice')
script_version		('1.2')

require "moonloader"
require 'lib.vkeys'
local dlstatus 										= require "moonloader".download_status
local inicfg 											= require 'inicfg'
local sampevcheck, sampev					= pcall(require, "samp.events")
local imguicheck, imgui						= pcall(require, "imgui")
local facheck, fa									= pcall(require, "fAwesome5")
local memory      								= require 'memory'
local encodingcheck, encoding			= pcall(require, "encoding")
encoding.default = 'CP1251'
u8 = encoding.UTF8

local fa_font = nil
local fontsize20 = nil
local fontsize30 = nil
local fontsize50 = nil
local fontsize501 = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
	if fa_font == nil then
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 15.0, font_config, fa_glyph_ranges)
	end

	if fontsize20 == nil then
		fontsize20 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 20.0, font_config, fa_glyph_ranges)
	end

	if fontsize30 == nil then
		fontsize30 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 30.0, font_config, fa_glyph_ranges)
	end

	if fontsize50 == nil then
		fontsize50 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 40.0, font_config, fa_glyph_ranges)
	end

	if fontsize501 == nil then
		fontsize501 = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 45.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
	end
end

local cfg = inicfg.load({
	Settings = {
		FirstSettings = false,
		rank = 'Охранник',
		rankAndNumber = '1',
		RP = true,
		waitRP = 2.5,
		sex = 1,
		aupdate = true
	},
	Binds_Name = {},
	Binds_Action = {},
	Binds_Deleay = {}
}, "Government Helper")

local tag = '{ADFF2F}[Government Helper] {FFFFFF}'
local mc = 0xADFF2F
local sc = '{ADFF2F}'
------------
local window = imgui.ImBool(false)
local help = imgui.ImBool(false)
local omenu = imgui.ImBool(false)
local rank = imgui.ImBuffer(''..cfg.Settings.rank,30)
local rankAndNumber = imgui.ImBuffer(''..cfg.Settings.rankAndNumber,30)
local RP = imgui.ImBool(cfg.Settings.RP)
local waitRP = imgui.ImFloat(cfg.Settings.waitRP)
local sex = imgui.ImInt(cfg.Settings.sex)
local aupdate = imgui.ImBool(cfg.Settings.aupdate)
local FirstSettings = imgui.ImBool(cfg.Settings.FirstSettings)
local binder_delay = imgui.ImInt(2500)
local text_binder = imgui.ImBuffer(65536)
local text_ustav = imgui.ImBuffer(65536)
local binder_name = imgui.ImBuffer(35)
local ReasonUval = imgui.ImBuffer(50)
local giverankInt = imgui.ImInt(1)
local IDplayer = imgui.ImInt(0)
------------
fileconfig = getWorkingDirectory()..'//config//Government Helper.ini'
local getRankInStats = false
local owner = false

local owners = {
	'Quinrage_Cartel'
}

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(200) end
	while not sampIsLocalPlayerSpawned() do wait(0) end

	local checking = checklibs()
	while not checking do
	wait(200)
	end

	log('Подготовка к запуску...')

	imgui.Process = false

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)

	local ip, port = sampGetCurrentServerAddress()
	for i=1, #owners do
		if nick == owners[i] and ip == '185.169.134.107' then
			owner = true
			log('Вы вошли в режим Разработчика!')
		end
	end

	if not checkServer(select(1, sampGetCurrentServerAddress())) then
		GHsms('Скрипт работает только на проекте '..sc..'Arizona RP')
		thisScript():unload()
		else
		GHsms('Скрипт запущен! Активация - /gh')
		checkOrg()
	end

	sampRegisterChatCommand('gh', function()
		if not omenu.v then
			window.v = not window.v
			menu = 1
			else
			GHsms('Выключите меню взаимодействия, чтобы открыть данное меню!')
		end
	end)

	sampRegisterChatCommand('gha', function()
		if not omenu.v then
			help.v = not help.v
			else
			GHsms('Выключите меню взаимодействия, чтобы открыть данное меню!')
		end
	end)

	--[[sampRegisterChatCommand('ghm', function()
		window.v = false
		help.v = false
		omenu.v = true
		imgui.ShowCursor = true
	end)]]

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('givepass', function(givepass_id)
			local givepass_id = givepass_id:match('(%d+)')
			if tonumber(givepass_id) then
				lua_thread.create(function()
					sampSendChat("/me {sex:достал|достала} чистое заявление с незаполненными полями и {sex:положил|положила} его перед человеком")
					wait(waitRP.v * 1000)
					sampSendChat("/todo Вам нужно будет заполнить все поля в заявление*передавая ручку человеку")
					wait(waitRP.v * 1000)
					sampSendChat("/givepass "..givepass_id)
					wait(waitRP.v * 1000)
					sampSendChat("/do Все нужные поля в заявление были заполнены.")
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:проверил|проверила} занесенные поля и {sex:занёс|занесла} их в паспорт")
					wait(waitRP.v * 1000)
					sampSendChat("/todo Хорошего дня!*передавая паспорт человеку")
				end)
				else
				GHsms('Используй: /givepass [id]')
			end
		end)
		else
		sampUnregisterChatCommand('givepass')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('uninvite', function(uninv_id)
			local uninv_id, uninv_reason = uninv_id:match('(%d+) (.+)')
			if tonumber(uninv_id) and uninv_reason then
				lua_thread.create(function()
					sampSendChat("/me {sex:достал|достала} планшет и {sex:открыл|открыла} базу данных")
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:перешёл|перешла} в раздел «Сотрудники» и {sex:нашёл|нашла} там "..rpNick(tonumber(uninv_id)))
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:выбрал|выбрала} сотрудника и {sex:нажал|нажала} «Уволить»")
					wait(waitRP.v * 1000)
					sampSendChat('/uninvite '..tostring(uninv_id)..' '..tostring(uninv_reason))
				end)
				else
				GHsms('Используй: /uninvite [id] [причина]')
			end
		end)
		else
		sampUnregisterChatCommand('uninvite')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('invite', function(invite_id)
			local invite_id = invite_id:match('(%d+)')
			if tonumber(invite_id) then
				lua_thread.create(function()
					sampSendChat("/me {sex:достал|достала} планшет и {sex:открыл|открыла} базу данных")
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:перешёл|перешла} в раздел «Сотрудники» и {sex:внёс|внесла} туда нового сотрудника "..rpNick(tonumber(invite_id)))
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:передал|передала} сотруднику ключи от шкафчика")
					wait(waitRP.v * 1000)
					sampSendChat('/invite '..tostring(invite_id))
				end)
				else
				GHsms('Используй: /invite [id]')
			end
		end)
		else
		sampUnregisterChatCommand('invite')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('giverank', function(giverank_id)
			local giverank_id, giverank_rank = giverank_id:match('(%d+) (%d+)')
			if tonumber(giverank_id) and tonumber(giverank_rank) then
				lua_thread.create(function()
					sampSendChat('/me {sex:достал|достала} из кармана КПК')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:включил|включила} КПК и {sex:зашёл|зашла} в раздел «Сотрудники»')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:выбрал|выбрала} сотрудника '..rpNick(tonumber(giverank_id)))
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:обновил|обновила} должность сотруднику')
					wait(waitRP.v * 1000)
					sampSendChat('/giverank '..tostring(giverank_id)..' '..tostring(giverank_rank))
				end)
				else
				GHsms('Используй: /giverank [id] [rank]')
			end
		end)
		else
		sampUnregisterChatCommand('giverank')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('fwarn', function(fwarn_id)
			local fwarn_id, fwarn_reason = fwarn_id:match('(%d+) (.+)')
			if tonumber(fwarn_id) and tostring(fwarn_reason) then
				lua_thread.create(function()
					sampSendChat('/me {sex:достал|достала} из кармана КПК')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:включил|включила} КПК и {sex:зашёл|зашла} в раздел «Сотрудники»')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:выбрал|выбрала} сотрудника '..rpNick(tonumber(fwarn_id)))
					wait(waitRP.v * 1000)
					sampSendChat('/me в меню {sex:выбрал|выбрала} пункт «Выдать выговор»')
					wait(waitRP.v * 1000)
					sampSendChat('/fwarn '..tostring(fwarn_id)..' '..tostring(fwarn_reason))
				end)
				else
				GHsms('Используй: /fwarn [id] [reason]')
			end
		end)
		else
		sampUnregisterChatCommand('fwarn')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('demoute', function(demoute_id)
			local demoute_id, demoute_reason = demoute_id:match('(%d+) (.+)')
			if tonumber(demoute_id) and tostring(demoute_reason) then
				lua_thread.create(function()
					sampSendChat('/me {sex:достал|достала} из кармана КПК')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:включил|включила} КПК и {sex:зашёл|зашла} в раздел «Государственные организации»')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:выбрал|выбрала} сотрудника '..rpNick(tonumber(demoute_id)))
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:вынес|вынесла} сотрудника из базы данных')
					wait(waitRP.v * 1000)
					sampSendChat('/demoute '..tostring(demoute_id)..' '..tostring(demoute_reason))
				end)
				else
				GHsms('Используй: /demoute [id] [reason]')
			end
		end)
		else
		sampUnregisterChatCommand('demoute')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('uninviteoff', function(uninviteoff_nick)
			local uninviteoff_nick = uninviteoff_nick:match('(.+)')
			if uninviteoff_nick == nil or uninviteoff_nick == '' then
				GHsms('Используй: /uninviteoff [nick]')
				else
				lua_thread.create(function()
					sampSendChat("/me {sex:достал|достала} КПК и {sex:открыл|открыла} базу данных")
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:перешёл|перешла} в раздел «Сотрудники»")
					wait(waitRP.v * 1000)
					sampSendChat("/me {sex:выбрал|выбрала} сотрудника и {sex:нажал|нажала} «Уволить»")
					wait(waitRP.v * 1000)
					sampSendChat('/uninviteoff '..tostring(uninviteoff_nick))
				end)
			end
		end)
		else
		sampUnregisterChatCommand('uninviteoff')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('expel', function(expel_id)
			local expel_id, expel_reason = expel_id:match('(%d+) (.+)')
			if tonumber(expel_id) and tostring(expel_reason) then
				lua_thread.create(function()
					sampSendChat('Мне придётся вывести вас из здания Правительства.')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:схватил|схватила} за руку и {sex:повёл|повела} к выходу '..rpNick(tonumber(expel_id)))
					wait(waitRP.v * 1000)
					sampSendChat('/todo А теперь подумайте над своим поведением!*закрывая дверь здания..')
					wait(waitRP.v * 1000)
					sampSendChat('/expel '..tostring(expel_id)..' '..tostring(expel_reason))
				end)
				else
				GHsms('Используй: /expel [id] [reason]')
			end
		end)
		else
			sampUnregisterChatCommand('expel')
	end

	if cfg.Settings.RP == true then
		sampRegisterChatCommand('unfwarn', function(unfwarn_id)
			local unfwarn_id = unfwarn_id:match('(%d+)')
			if tonumber(unfwarn_id) then
				lua_thread.create(function()
					sampSendChat('/me {sex:достал|достала} из кармана КПК')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:включил|включила} КПК и {sex:зашёл|зашла} в раздел «Сотрудники»')
					wait(waitRP.v * 1000)
					sampSendChat('/me {sex:выбрал|выбрала} сотрудника '..rpNick(tonumber(unfwarn_id)))
					wait(waitRP.v * 1000)
					sampSendChat('/me в меню {sex:выбрал|выбрала} пункт «Снять выговор»')
					wait(waitRP.v * 1000)
					sampSendChat('/unfwarn '..tostring(fwarn_id))
				end)
			else
				GHsms('Используй: /unfwarn [id]')
			end
		end)
		else
			sampUnregisterChatCommand('unfwarn')
	end

	log('Скрипт готов к работе!')

	while true do
		wait(0)
		if window.v or help.v or omenu.v then
			imgui.Process = true
			imgui.ShowCursor = true
		else
			imgui.Process = false
			imgui.ShowCursor = false
		end
		local result, id = sampGetPlayerIdOnTargetKey(VK_Q)
		if result then
			GHsms('Выбран игрок: '..sampGetPlayerNickname(id)..' ['..id..']')
			IDplayer.v = id
			window.v = false
			help.v = false
			omenu.v = true
			imgui.ShowCursor = true
		end
	end
end

function sampGetPlayerIdOnTargetKey(key)
	local result, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
	if result then
		if isKeyJustPressed(key) then
			return sampGetPlayerIdByCharHandle(ped)
		end
	end
	return false
end

function autoupdate(json_url, tag, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(tag)
                local dlstatus = require('moonloader').download_status
                sampAddChatMessage(('['..thisScript().name..'] {FFFFFF}Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), mc)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      log(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      log('Загрузка обновления завершена.')
                      sampAddChatMessage(('['..thisScript().name..'] {FFFFFF}Обновление завершено! Перезагружаю скрипт.'), mc)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage(('['..thisScript().name..'] {FFFFFF}Обновление прошло неудачно. Запускаю устаревшую версию..'), mc)
                        update = false
                      end
                    end
                  end
                )
		end, tag
              )
            else
              update = false
              log('Обновление не требуется! Актуальная версия: '..thisScript().version)
            end
          end
        else
          sampAddChatMessage('['..thisScript().name..'] {FFFFFF}Не могу проверить обновление. Проверьте обновление в теме на BlastHack: '..url, mc)
					sampAddChatMessage('['..thisScript().name..'] {FFFFFF}Ссылка на тему BlastHack продублирована в консоли SF', mc)
					  log('Ссылка на тему BlastHack: '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function GHsms(text)
	sampAddChatMessage("{ADFF2F}[Government Helper] {FFFFFF}"..text, 0xADFF2F)
end

function imgui.OnDrawFrame()
	if window.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8'##MainMenu', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
		--imgui.ShowStyleEditor()
		imgui.BeginGroup()
		imgui.PushFont(fontsize50)
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], fa.ICON_FA_UNIVERSITY)
		imgui.PopFont()
		imgui.SameLine()
		imgui.PushFont(fontsize501)
		imgui.TextColoredRGB('{73b012}Government')
		imgui.PopFont()
		imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() - 40, 16))
		imgui.PushFont(fontsize30)
		imgui.Text(fa.ICON_FA_TIMES_CIRCLE)
		imgui.PopFont()
		if imgui.IsItemClicked() then
		lua_thread.create(function()
		wait(75)
		window.v = not window.v
		end) end
		imgui.EndGroup()
		imgui.BeginGroup()
		imgui.BeginChild('up', imgui.ImVec2(250, 150), true)
		imgui.SetCursorPosY(25)
		imgui.PushFont(fontsize50)
		imgui.CenterText(fa.ICON_FA_USER_CIRCLE, imgui.GetStyle().Colors[imgui.Col.ButtonActive])
		imgui.PopFont()
		imgui.CenterTextColoredRGB(sc..cfg.Settings.rank)
		imgui.CenterTextColoredRGB(sc..'('..cfg.Settings.rankAndNumber..')')
		imgui.NewLine()
		imgui.SetCursorPosX((imgui.GetWindowWidth() - 100) / 2)
		if imgui.Button(u8'Обновить', imgui.ImVec2(100,20)) then
			checkOrg()
			else
			imgui.Hint(u8'Нажмите, чтобы обновить данные статистики.')
		end
		imgui.EndChild()
		if imgui.Button(fa.ICON_FA_USER..u8" Биндер", imgui.ImVec2(250,30)) then menu = 1 end
		--if imgui.Button(fa.ICON_FA_INFO_CIRCLE..u8" Правила", imgui.ImVec2(250,30)) then menu = 2 end
		if imgui.Button(fa.ICON_FA_COG..u8" Настройки", imgui.ImVec2(250,30)) then menu = 3 end
		imgui.EndGroup()
		imgui.SameLine()
		imgui.BeginGroup()
		imgui.BeginChild('right', imgui.ImVec2(400, 300), true)
		if menu == 1 then
			imgui.CenterTextColoredRGB(sc..'Меню пользовательских биндов')
			imgui.Separator()
			if #cfg.Binds_Name > 0 then
			for key_bind, name_bind in pairs(cfg.Binds_Name) do
			if imgui.Button(name_bind..'##'..key_bind, imgui.ImVec2(312, 30)) then
			play_bind(key_bind)
			window.v = false
			end
			imgui.SameLine()
			if imgui.Button(fa.ICON_FA_PEN..'##'..key_bind, imgui.ImVec2(30, 30)) then
			EditOldBind = true
			getpos = key_bind
			binder_delay.v = cfg.Binds_Deleay[key_bind]
			local returnwrapped = tostring(cfg.Binds_Action[key_bind]):gsub('~', '\n')
			text_binder.v = returnwrapped
			binder_name.v = tostring(cfg.Binds_Name[key_bind])
			imgui.OpenPopup(u8'Биндер')
			end
			imgui.SameLine()
			if imgui.Button(fa.ICON_FA_TRASH..'##'..key_bind, imgui.ImVec2(30, 30)) then
			GHsms('Бинд «'..u8:decode(cfg.Binds_Name[key_bind])..'» удалён!') --[[« »]]
			table.remove(cfg.Binds_Name, key_bind)
			table.remove(cfg.Binds_Action, key_bind)
			table.remove(cfg.Binds_Deleay, key_bind)
			inicfg.save(cfg, 'Government Helper.ini')
			end
			end
			else
			imgui.CenterTextColoredRGB('Здесь пока нету Ваших биндов.')
			imgui.CenterTextColoredRGB('Их можно создать!')
			imgui.SetCursorPosX((imgui.GetWindowWidth() - 25) / 2)
			imgui.PushFont(fontsize50)
			imgui.Text(fa.ICON_FA_CHILD)
			imgui.PopFont()
			end
			imgui.Separator()
			if imgui.Button(fa.ICON_FA_PLUS_CIRCLE..u8' Создать бинд', imgui.ImVec2(-1,30)) then
			imgui.OpenPopup(u8'Биндер')
			binder_delay.v = 2500
			end

			end

			if imgui.BeginPopupModal(u8'Биндер', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
			imgui.BeginChild("##EditBinder", imgui.ImVec2(600, 337), true)
			imgui.PushItemWidth(150)
			imgui.InputInt(u8("Задержка между строками в миллисекундах"), binder_delay); imgui.SameLine(); imgui.Vopros(); imgui.Hint(u8'Не больше 60.000 ms!\n(1 sec = 1000 ms)')
			imgui.PopItemWidth()
			if binder_delay.v <= 0 then
			binder_delay.v = 1
			elseif binder_delay.v >= 60001 then
			binder_delay.v = 60000
			end
			imgui.SameLine()
			if imgui.Button(u8'Локальные тэги##LocalTag', imgui.ImVec2(140,20)) then
			imgui.OpenPopup(u8'Локальные тэги')
			end
			localtag()
			imgui.InputTextMultiline("##EditMultiline", text_binder, imgui.ImVec2(-1, 250))
			imgui.Text(u8'Название бинда (обязательно):'); imgui.SameLine()
			imgui.PushItemWidth(200)
			imgui.InputText("##binder_name", binder_name)
			imgui.PopItemWidth()

			if #binder_name.v > 0 and #text_binder.v > 0 then
			imgui.SameLine()
			if imgui.Button(u8'Сохранить##bind1', imgui.ImVec2(-1,20)) then
			if not EditOldBind then
			refresh_text = text_binder.v:gsub("\n", "~")
			table.insert(cfg.Binds_Name, binder_name.v)
			table.insert(cfg.Binds_Action, refresh_text)
			table.insert(cfg.Binds_Deleay, binder_delay.v)
			if inicfg.save(cfg, 'Government Helper.ini') then
			GHsms('Бинд «'..u8:decode(binder_name.v)..'» успешно добавлен!')
			binder_name.v, text_binder.v = '', ''
			end
			imgui.CloseCurrentPopup()
			else
			refresh_text = text_binder.v:gsub("\n", "~")
			table.insert(cfg.Binds_Name, getpos, binder_name.v)
			table.insert(cfg.Binds_Action, getpos, refresh_text)
			table.insert(cfg.Binds_Deleay, getpos, binder_delay.v)
			table.remove(cfg.Binds_Name, getpos + 1)
			table.remove(cfg.Binds_Action, getpos + 1)
			table.remove(cfg.Binds_Deleay, getpos + 1)
			if inicfg.save(cfg, 'Government Helper.ini') then
			GHsms('Бинд «'..u8:decode(binder_name.v)..'» успешно отредактирован!')
			binder_name.v, text_binder.v = '', ''
			end
			EditOldBind = false
			imgui.CloseCurrentPopup()
			end
			end
			else
			imgui.SameLine()
			imgui.DisableButton(u8'Сохранить##bind2', imgui.ImVec2(-1,20))
			imgui.Hint(u8'Заполнены не все пункты!')
			end

			if imgui.Button(u8'Закрыть', imgui.ImVec2(-1,20)) then
			if not EditOldBind then
			imgui.CloseCurrentPopup()
			binder_name.v, text_binder.v = '', ''
			else
			EditOldBind = false
			imgui.CloseCurrentPopup()
			binder_name.v, text_binder.v = '', ''
			end
			end
			imgui.EndChild()
			imgui.EndPopup()
		end
		--[[if menu == 2 then
			ustav = io.open(path, "r")
			for line in ustav:lines() do
			imgui.Text(line)
			end
			ustav:close()
		end]]
		if menu == 3 then
			imgui.CenterTextColoredRGB(sc..'Настройки скрипта')
			imgui.CenterTextColoredRGB('Все команды скрипта: '..sc..'/gha')
			imgui.NewLine()
			if imgui.CollapsingHeader(u8("Общие настройки")) then
				if imgui.Checkbox(u8'Авто-Обновление', aupdate) then
					cfg.Settings.aupdate = aupdate.v
					inicfg.save(cfg, 'Government Helper.ini')
				end
			end
			if imgui.CollapsingHeader(u8("Отыгровки скрипта")) then
			imgui.TextColoredRGB(sc..'Задержка между сообщениями в РП отыгровках:')
			imgui.PushItemWidth(100)
			if imgui.SliderFloat('##waitRP', waitRP, 0.5, 10.0, u8'%0.2f с.') then
			if waitRP.v < 0.5 then waitRP.v = 0.5 end
			if waitRP.v > 10.0 then waitRP.v = 10.0 end
			cfg.Settings.waitRP = waitRP.v
			inicfg.save(cfg, 'Government Helper.ini')
			end
			imgui.PopItemWidth()
			imgui.TextColoredRGB(sc..'РП отыгровки:')
			if imgui.Checkbox(u8'##RP', RP) then
			cfg.Settings.RP = RP.v
			if inicfg.save(cfg, 'Government Helper.ini') then GHsms('Скрипт был перезагружен, чтобы изменения вступили в силу!');showCursor(false);thisScript():reload() end
			else;imgui.Hint(u8'Чтобы настройки применились нужно перезапустить скрипт.')
			end
			imgui.SameLine()
			imgui.Text(u8(RP.v and 'Включено' or 'Выключено'))
			imgui.TextColoredRGB(sc..'Ваш пол:')
			if imgui.RadioButton(u8'Мужской##sex', sex, 1) then
			cfg.Settings.sex = sex.v
			inicfg.save(cfg, 'Government Helper.ini')
			end
			if imgui.RadioButton(u8'Женский##sex', sex, 2) then
			cfg.Settings.sex = sex.v
			inicfg.save(cfg, 'Government Helper.ini')
			end
			end
			if imgui.CollapsingHeader(u8("О скрипте")) then
			imgui.CenterTextColoredRGB('Автор скрипта: '..sc..'Rice')
			imgui.CenterTextColoredRGB('{868686}Нашли ошибку или есть предложение? Пишите сюда:')
			imgui.SetCursorPosX((imgui.GetWindowWidth() - 90) / 2)
			if imgui.Button(fa.ICON_FA_LINK..u8(" ВКонтакте"), imgui.ImVec2(90, 25)) then
			GHsms('Ссылка скопирована в буфер обмена!')
			setClipboardText("https://vk.com/id324119075")
			end
			end
			imgui.NewLine()
			if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(190, 30)) then
			showCursor(false)
			thisScript():reload()
			end
			imgui.SameLine()
			if imgui.Button(u8'Выключить скрипт', imgui.ImVec2(190, 30)) then
			showCursor(false)
			thisScript():unload()
			end
			imgui.SetCursorPosX((imgui.GetWindowWidth() - 190) / 2)
			if imgui.Button(u8'Сбросить настройки', imgui.ImVec2(190,30)) then
			imgui.OpenPopup(u8'##sbros')
			end

			if imgui.BeginPopupModal(u8"##sbros", false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
			imgui.TextColoredRGB('Вы уверены, что хотите {FF0000}сбросить{FFFFFF} настройки скрипта?')
			if imgui.Button(u8'Подтвердить', imgui.ImVec2(160, 20)) then
			if os.remove(fileconfig) then
			GHsms('Настройки были успешно сброшены!')
			showCursor(false)
			thisScript():reload()
			end
			end
			imgui.SameLine()
			if imgui.Button(u8'Отмена', imgui.ImVec2(160, 20)) then
			imgui.CloseCurrentPopup()
			end


			imgui.EndPopup()
			end
		end
		imgui.EndChild()
		imgui.EndGroup()
		imgui.End()
	end

	if help.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8'##Help', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
			imgui.CenterTextColoredRGB(sc..'Список команд:')
			imgui.CenterTextColoredRGB(sc..'/gh {FFFFFF}- Основное меню скрипта')
			imgui.CenterTextColoredRGB(sc..'/gha {FFFFFF}- Список всех команд')
			imgui.CenterTextColoredRGB(sc..'ПКМ + Q (по игроку) {FFFFFF}- Окно взаимодействия с игроками')
			imgui.Separator()
			imgui.CenterTextColoredRGB(sc..'/invite {FFFFFF}- Принять человека в организацию')
			imgui.CenterTextColoredRGB(sc..'/uninvite {FFFFFF}- Уволить сотрудника из организации')
			imgui.CenterTextColoredRGB(sc..'/giverank {FFFFFF}- Изменить ранг сотруднику')
			imgui.CenterTextColoredRGB(sc..'/givepass {FFFFFF}- Выдать паспорт человеку')
			imgui.CenterTextColoredRGB(sc..'/fwarn {FFFFFF}- Выдать выговор сотруднику')
			imgui.CenterTextColoredRGB(sc..'/unfwarn {FFFFFF}- Снять выговор сотруднику')
			imgui.CenterTextColoredRGB(sc..'/demoute {FFFFFF}- Уволить гос.сотрудника')
			imgui.CenterTextColoredRGB(sc..'/uninviteoff {FFFFFF}- Уволить сотрудника в оффлайне')
			imgui.CenterTextColoredRGB(sc..'/expel {FFFFFF}- Выгнать человека из здания Правительства')
			imgui.SetCursorPosX((imgui.GetWindowWidth() - 100) / 2)
			if imgui.Button(u8'Понятно##Команды', imgui.ImVec2(100,20)) then
				help.v = not help.v
			end
		imgui.End()
	end

--[[if omenu.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2((sw - 505) / 2, sh / 1.165), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8'##menu2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
			imgui.PushItemWidth(90)
			imgui.InputInt(u8'ID игрока', IDplayer)
			imgui.PopItemWidth()
			if IDplayer.v > 999 then IDplayer.v = 999 end
			if IDplayer.v < 0 then IDplayer.v = 0 end
			imgui.BeginChild('##menu2Child', imgui.ImVec2(505, 85), true)
				if imgui.Button(u8'Выгнать##menu2', imgui.ImVec2(160,20)) then
					sampProcessChatInput('/expel '..tonumber(IDplayer.v)..' Н.П.П.')
				end
				imgui.SameLine()
				if imgui.Button(u8'Выдать паспорт##menu2', imgui.ImVec2(160,20)) then
					sampProcessChatInput('/givepass '..tonumber(IDplayer.v))
				end
				imgui.SameLine()
				if imgui.Button(u8'Уволить гос. сотрудника##menu2', imgui.ImVec2(160,20)) then
					imgui.OpenPopup(u8'Уволить##2menu2')
				end
				if imgui.Button(u8'Принять в орг.##menu2', imgui.ImVec2(160,20)) then
					sampProcessChatInput('/invite '..tonumber(IDplayer.v))
				end
				imgui.SameLine()
				if imgui.Button(u8'Уволить из орг.##menu2', imgui.ImVec2(160	,20)) then
					imgui.OpenPopup(u8'Уволить##1menu2')
				end
				imgui.SameLine()
				if imgui.Button(u8'Выдать выговор##menu2', imgui.ImVec2(160	,20)) then
					imgui.OpenPopup(u8'Выговор##menu2')
				end
				if imgui.Button(u8'Снять выговор##menu2', imgui.ImVec2(160	,20)) then
					sampProcessChatInput('/unfwarn '..tonumber(IDplayer.v))
				end
				imgui.SameLine()
				if imgui.Button(u8'Изменить должность##menu2', imgui.ImVec2(160	,20)) then
					imgui.OpenPopup(u8'Должность##menu2')
				end
				if imgui.BeginPopupModal(u8'Уволить##1menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
					imgui.PushItemWidth(150)
					imgui.InputText(u8'Причина увольнения##Уволить из орг.', ReasonUval)
					imgui.PopItemWidth()
					if imgui.Button(u8'Отправить##Уволить из орг.', imgui.ImVec2(200, 20)) then
						sampProcessChatInput('/uninvite '..tonumber(IDplayer.v)..' '..ReasonUval.v)
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.SameLine()
					if imgui.Button(u8'Закрыть##Уволить из орг.', imgui.ImVec2(200, 20)) then
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.EndPopup()
				end
				if imgui.BeginPopupModal(u8'Уволить##2menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
					imgui.PushItemWidth(150)
					imgui.InputText(u8'Причина увольнения##Уволить гос. сотрудника', ReasonUval)
					imgui.PopItemWidth()
					if imgui.Button(u8'Отправить##Уволить гос. сотрудника', imgui.ImVec2(200, 20)) then
						sampProcessChatInput('/demoute '..tonumber(IDplayer.v)..' '..ReasonUval.v)
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.SameLine()
					if imgui.Button(u8'Закрыть##Уволить гос. сотрудника', imgui.ImVec2(200, 20)) then
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.EndPopup()
				end
				if imgui.BeginPopupModal(u8'Выговор##menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
					imgui.PushItemWidth(150)
					imgui.InputText(u8'Причина выговора##3menu2', ReasonUval)
					imgui.PopItemWidth()
					if imgui.Button(u8'Отправить##3menu2', imgui.ImVec2(200, 20)) then
						sampProcessChatInput('/fwarn '..tonumber(IDplayer.v)..' '..ReasonUval.v)
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.SameLine()
					if imgui.Button(u8'Закрыть##3menu2', imgui.ImVec2(200, 20)) then
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.EndPopup()
				end
				if imgui.BeginPopupModal(u8'Должность##menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
					imgui.PushItemWidth(30)
					imgui.InputText(u8'Номер должности##4menu2', ReasonUval)
					imgui.PopItemWidth()
					if imgui.Button(u8'Отправить##4menu2', imgui.ImVec2(200, 20)) then
						sampProcessChatInput('/giverank '..tonumber(IDplayer.v)..' '..ReasonUval.v)
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.SameLine()
					if imgui.Button(u8'Закрыть##4menu2', imgui.ImVec2(200, 20)) then
						imgui.CloseCurrentPopup()
						ReasonUval.v = ''
					end
					imgui.EndPopup()
				end
			imgui.EndChild()
			imgui.CenterTextColoredRGB('{868686}Курсор (?)');imgui.Hint(u8'Включить/выключить курсор - сочетания клавиш "GC"')
			imgui.SetCursorPosX((imgui.GetWindowWidth() - 150) / 2)
			if imgui.Button(u8'Закрыть##menu2', imgui.ImVec2(150,20)) then
				omenu.v = false
				imgui.ShowCursor = false
			end
		imgui.End()
	end
end]]
if omenu.v then
	local sw, sh = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2((sw - 505) / 2, sh / 1.140), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(u8'##menu2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
		imgui.PushItemWidth(90)
		imgui.CenterText(sampGetPlayerNickname(IDplayer.v)..' ['..IDplayer.v..']')
		imgui.PopItemWidth()
		if IDplayer.v > 999 then IDplayer.v = 999 end
		if IDplayer.v < 0 then IDplayer.v = 0 end
		imgui.BeginChild('##menu2Child', imgui.ImVec2(505, 85), true)
			if imgui.Button(u8'Выгнать##menu2', imgui.ImVec2(160,20)) then
				sampProcessChatInput('/expel '..tonumber(IDplayer.v)..' Н.П.П.')
			end
			imgui.SameLine()
			if imgui.Button(u8'Выдать паспорт##menu2', imgui.ImVec2(160,20)) then
				sampProcessChatInput('/givepass '..tonumber(IDplayer.v))
			end
			imgui.SameLine()
			if imgui.Button(u8'Уволить гос. сотрудника##menu2', imgui.ImVec2(160,20)) then
				imgui.OpenPopup(u8'Уволить##2menu2')
			end
			if imgui.Button(u8'Принять в орг.##menu2', imgui.ImVec2(160,20)) then
				sampProcessChatInput('/invite '..tonumber(IDplayer.v))
			end
			imgui.SameLine()
			if imgui.Button(u8'Уволить из орг.##menu2', imgui.ImVec2(160	,20)) then
				imgui.OpenPopup(u8'Уволить##1menu2')
			end
			imgui.SameLine()
			if imgui.Button(u8'Выдать выговор##menu2', imgui.ImVec2(160	,20)) then
				imgui.OpenPopup(u8'Выговор##menu2')
			end
			if imgui.Button(u8'Снять выговор##menu2', imgui.ImVec2(160	,20)) then
				sampProcessChatInput('/unfwarn '..tonumber(IDplayer.v))
			end
			imgui.SameLine()
			if imgui.Button(u8'Изменить должность##menu2', imgui.ImVec2(160	,20)) then
				imgui.OpenPopup(u8'Должность##menu2')
			end
			if imgui.BeginPopupModal(u8'Уволить##1menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
				imgui.PushItemWidth(150)
				imgui.InputText(u8'Причина увольнения##Уволить из орг.', ReasonUval)
				imgui.PopItemWidth()
				if imgui.Button(u8'Отправить##Уволить из орг.', imgui.ImVec2(200, 20)) then
					sampProcessChatInput('/uninvite '..tonumber(IDplayer.v)..' '..ReasonUval.v)
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.SameLine()
				if imgui.Button(u8'Закрыть##Уволить из орг.', imgui.ImVec2(200, 20)) then
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.EndPopup()
			end
			if imgui.BeginPopupModal(u8'Уволить##2menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
				imgui.PushItemWidth(150)
				imgui.InputText(u8'Причина увольнения##Уволить гос. сотрудника', ReasonUval)
				imgui.PopItemWidth()
				if imgui.Button(u8'Отправить##Уволить гос. сотрудника', imgui.ImVec2(200, 20)) then
					sampProcessChatInput('/demoute '..tonumber(IDplayer.v)..' '..ReasonUval.v)
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.SameLine()
				if imgui.Button(u8'Закрыть##Уволить гос. сотрудника', imgui.ImVec2(200, 20)) then
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.EndPopup()
			end
			if imgui.BeginPopupModal(u8'Выговор##menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
				imgui.PushItemWidth(150)
				imgui.InputText(u8'Причина выговора##3menu2', ReasonUval)
				imgui.PopItemWidth()
				if imgui.Button(u8'Отправить##3menu2', imgui.ImVec2(200, 20)) then
					sampProcessChatInput('/fwarn '..tonumber(IDplayer.v)..' '..ReasonUval.v)
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.SameLine()
				if imgui.Button(u8'Закрыть##3menu2', imgui.ImVec2(200, 20)) then
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.EndPopup()
			end
			if imgui.BeginPopupModal(u8'Должность##menu2', _, imgui.WindowFlags.AlwaysAutoResize) then
				imgui.PushItemWidth(70)
				imgui.InputInt(u8'Номер должности##4menu2', giverankInt)
				imgui.PopItemWidth()
				if giverankInt.v > 9 then
					giverankInt.v = 9
				end
				if giverankInt.v < 1 then
					giverankInt.v = 1
				end
				if imgui.Button(u8'Отправить##4menu2', imgui.ImVec2(200, 20)) then
					sampProcessChatInput('/giverank '..tonumber(IDplayer.v)..' '..giverankInt.v)
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.SameLine()
				if imgui.Button(u8'Закрыть##4menu2', imgui.ImVec2(200, 20)) then
					imgui.CloseCurrentPopup()
					ReasonUval.v = ''
				end
				imgui.EndPopup()
			end
		imgui.EndChild()
		imgui.SetCursorPosX((imgui.GetWindowWidth() - 150) / 2)
		if imgui.Button(u8'Закрыть##menu2', imgui.ImVec2(150,20)) then
			omenu.v = false
			imgui.ShowCursor = false
		end
	imgui.End()
end
end

function theme()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 10
	style.ChildWindowRounding = 10
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 3.0
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10.0
	style.ScrollbarRounding = 13
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 0.78)
	colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]              = ImVec4(0.25, 0.29, 0.20, 1.00)
	colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg]              = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgActive]        = ImVec4(0.35, 0.58, 0.06, 1.00)
	colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark]            = ImVec4(0.72, 1.00, 0.28, 1.00)
	colors[clr.SliderGrab]           = ImVec4(0.43, 0.57, 0.05, 1.00)
	colors[clr.SliderGrabActive]     = ImVec4(0.55, 0.67, 0.15, 1.00)
	colors[clr.Button]               = ImVec4(0.40, 0.57, 0.01, 1.00)
	colors[clr.ButtonHovered]        = ImVec4(0.45, 0.69, 0.07, 1.00)
	colors[clr.ButtonActive]         = ImVec4(0.27, 0.50, 0.00, 1.00)
	colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered]        = ImVec4(0.72, 0.98, 0.26, 0.80)
	colors[clr.HeaderActive]         = ImVec4(0.74, 0.98, 0.26, 1.00)
	colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
	colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
	colors[clr.ResizeGrip]           = ImVec4(0.68, 0.98, 0.26, 0.25)
	colors[clr.ResizeGripHovered]    = ImVec4(0.72, 0.98, 0.26, 0.67)
	colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
theme()

function imgui.CenterText(text, color)
	color = color or imgui.GetStyle().Colors[imgui.Col.Text]
	local width = imgui.GetWindowWidth()
	for line in text:gmatch('[^\n]+') do
		local lenght = imgui.CalcTextSize(line).x
		imgui.SetCursorPosX((width - lenght) / 2)
		imgui.TextColored(color, line)
	end
end

function play_bind(num)
	lua_thread.create(function()
		if num ~= -1 then
			for bp in cfg.Binds_Action[num]:gmatch('[^~]+') do
				sampSendChat(u8:decode(tostring(bp)))
				wait(cfg.Binds_Deleay[num])
			end
			num = -1
		end
	end)
end

function imgui.Hint(text, delay, action)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5 -- скорость появления
		if os.clock() >= go_hint then
			imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
			imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
			imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(700)
			imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonActive], fa.ICON_FA_INFO_CIRCLE..u8' Подсказка:')
			imgui.TextUnformatted(text)
			if action ~= nil then
				imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n'..fa.ICON_FA_SHARE..' '..action)
			end
			if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
			imgui.PopStyleColor()
			imgui.PopStyleVar(2)
		end
	end
end

function imgui.DisableButton(text, size)
	imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.0, 0.0, 0.0, 0.2))
	local button = imgui.Button(text, size)
	imgui.PopStyleColor(3)
	return button
end

function imgui.CenterTextColoredRGB(text)
	local width = imgui.GetWindowWidth()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
	end

	local getcolor = function(color)
	if color:sub(1, 6):upper() == 'SSSSSS' then
	local r, g, b = colors[1].x, colors[1].y, colors[1].z
	local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
	return ImVec4(r, g, b, a / 255)
	end
	local color = type(color) == 'string' and tonumber(color, 16) or color
	if type(color) ~= 'number' then return end
	local r, g, b, a = explode_argb(color)
	return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
	for w in text_:gmatch('[^\r\n]+') do
	local textsize = w:gsub('{.-}', '')
	local text_width = imgui.CalcTextSize(u8(textsize))
	imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
	local text, colors_, m = {}, {}, 1
	w = w:gsub('{(......)}', '{%1FF}')
	while w:find('{........}') do
	local n, k = w:find('{........}')
	local color = getcolor(w:sub(n + 1, k - 1))
	if color then
	text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
	colors_[#colors_ + 1] = color
	m = n
	end
	w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
	end
	if text[0] then
	for i = 0, #text do
	imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
	imgui.SameLine(nil, 0)
	end
	imgui.NewLine()
	else
	imgui.Text(u8(w))
	end
	end
	end
	render_text(text)
end

function imgui.TextColoredRGB(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
	end

	local getcolor = function(color)
	if color:sub(1, 6):upper() == 'SSSSSS' then
	local r, g, b = colors[1].x, colors[1].y, colors[1].z
	local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
	return ImVec4(r, g, b, a / 255)
	end
	local color = type(color) == 'string' and tonumber(color, 16) or color
	if type(color) ~= 'number' then return end
	local r, g, b, a = explode_argb(color)
	return imgui.ImColor(r, g, b, a):GetVec4()
	end

	local render_text = function(text_)
	for w in text_:gmatch('[^\r\n]+') do
	local text, colors_, m = {}, {}, 1
	w = w:gsub('{(......)}', '{%1FF}')
	while w:find('{........}') do
	local n, k = w:find('{........}')
	local color = getcolor(w:sub(n + 1, k - 1))
	if color then
	text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
	colors_[#colors_ + 1] = color
	m = n
	end
	w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
	end
	if text[0] then
	for i = 0, #text do
	imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
	imgui.SameLine(nil, 0)
	end
	imgui.NewLine()
	else imgui.Text(u8(w)) end
	end
	end
	render_text(text)
end

function imgui.Vopros()
	imgui.TextDisabled(fa.ICON_FA_QUESTION_CIRCLE)
end

tServers = {
	'185.169.134.3',
	'185.169.134.4',
	'185.169.134.43',
	'185.169.134.44',
	'185.169.134.45',
	'185.169.134.5',
	'185.169.134.59',
	'185.169.134.61',
	'185.169.134.107',
	'185.169.134.109',
	'185.169.134.166',
	'185.169.134.171',
	'185.169.134.172',
	'185.169.134.173',
	'185.169.134.174',
	'80.66.82.191',
	'80.66.82.190'
}

function checkServer(ip)
	for k, v in pairs(tServers) do
		if v == ip then
			return true
		end
	end
	return false
end

function log(text)
	sampfuncsLog(sc..'Government-Helper: {FFFFFF}'..text)
end

function rpNick(id)
	local nick = sampGetPlayerNickname(id)
	if nick:match('_') then return nick:gsub('_', ' ') end
	return nick
end

function checkOrg()
	while not sampIsLocalPlayerSpawned() do wait(1000) end
	if sampIsLocalPlayerSpawned() then
		GHsms('Проверяю данные из Вашей статистики.')
		getRankInStats = true
		sampSendChat('/stats')
	end
end

if sampevcheck then
	function sampev.onSendChat(msg)
		if msg:find('{sex:%A+|%A+}') then
			local male, female = msg:match('{sex:(%A+)|(%A+)}')
			if cfg.Settings.sex == 1 then
				local returnMsg = msg:gsub('{sex:%A+|%A+}', male, 1)
				sampSendChat(tostring(returnMsg))
				return false
				else
				local returnMsg = msg:gsub('{sex:%A+|%A+}', female, 1)
				sampSendChat(tostring(returnMsg))
				return false
			end
		end
		if msg:find('{my:name}') then
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local returnMsg = msg:gsub('{my:name}', rpNick(myid))
			sampSendChat(returnMsg)
			return false
		end
		if msg:find('{my:id}') then
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local returnMsg = msg:gsub('{my:id}', myid)
			sampSendChat(returnMsg)
			return false
		end
		if msg:find('{my:rank}') then
			local returnMsg = msg:gsub('{my:rank}', cfg.Settings.rank)
			sampSendChat(returnMsg)
			return false
		end
		if msg:find('{time}') then
			local returnMsg = msg:gsub('{time}', '/time')
			sampSendChat(returnMsg)
			return false
		end
		if msg:find('{screen}') then
			Screen()
			local returnMsg = msg:gsub('{screen}', '')
			sampSendChat(returnMsg)
			return false
		end
	end
end

if sampevcheck then
	function sampev.onSendCommand(cmd)
		if cmd:find('{sex:%A+|%A+}') then
			local male, female = cmd:match('{sex:(%A+)|(%A+)}')
			if cfg.Settings.sex == 1 then
				local returnMsg = cmd:gsub('{sex:%A+|%A+}', male, 1)
				sampSendChat(tostring(returnMsg))
				return false
				else
				local returnMsg = cmd:gsub('{sex:%A+|%A+}', female, 1)
				sampSendChat(tostring(returnMsg))
				return false
			end
		end
		if cmd:find('{my:name}') then
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local returnMsg = cmd:gsub('{my:name}', rpNick(myid))
			sampSendChat(returnMsg)
			return false
		end
		if cmd:find('{my:id}') then
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local returnMsg = cmd:gsub('{my:id}', myid)
			sampSendChat(returnMsg)
			return false
		end
		if cmd:find('{my:rank}') then
			local returnMsg = cmd:gsub('{my:rank}', cfg.Settings.rank)
			sampSendChat(returnMsg)
			return false
		end
		if cmd:find('{time}') then
			local returnMsg = cmd:gsub('{time}', '/time')
			sampSendChat(returnMsg)
			return false
		end
		if cmd:find('{screen}') then
			Screen()
			local returnMsg = cmd:gsub('{screen}', '')
			sampSendChat(returnMsg)
			return false
		end
	end
end

if sampevcheck then
	function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
		if dialogId == 235 and getRankInStats then
			if not text:find('Правительство LS') and not owner then
				lua_thread.create(function()
					wait(1000)
					GHsms('Вы не в организации '..sc..'Правительство LS')
					GHsms('Скрипт работает только в этой организации')
					GHsms('Если вы считаете, что это ошибка - напишите разработчику '..sc..'vk.com/id324119075')
					GHsms('Скрипт отключен...')
					log('Скрипт отключен. Вы не в организации "Правительство LS"')
					wait(100)
					showCursor(false)
					thisScript():unload()
				end)
				return false
			end

			for DialogLine in text:gmatch('[^\r\n]+') do
				local nameRankStats, getStatsRank = DialogLine:match('Должность: {......}(.+)%((%d+)%)')
				local pol = DialogLine:match('Пол: {......}%[(.+)%]')
				if pol == 'Мужчина' and FirstSettings.v == false then
					GHsms('Пол автоматически установлен "Мужчина". Изменить можно в настройках скрипта.')
					sex.v = 1
					cfg.Settings.sex = sex.v
					FirstSettings.v = true
					cfg.Settings.FirstSettings = FirstSettings.v
					inicfg.save(cfg, 'Government Helper.ini')
					elseif pol == 'Женщина' and FirstSettings.v == false then
					GHsms('Пол автоматически установлен "Женщина". Изменить можно в настройках скрипта.')
					sex.v = 2
					cfg.Settings.sex = sex.v
					FirstSettings.v = true
					cfg.Settings.FirstSettings = FirstSettings.v
					inicfg.save(cfg, 'Government Helper.ini')
				end
				if tonumber(getStatsRank) then
					if tonumber(getStatsRank) ~= cfg.Settings.rankAndNumber then
						cfg.Settings.rankAndNumber = tonumber(getStatsRank)
						cfg.Settings.rank = tostring(nameRankStats)
						GHsms('Ранг обновлён на '..tostring(nameRankStats)..'('..tostring(getStatsRank)..')')
						inicfg.save(cfg, 'Government Helper.ini')
						else
						GHsms('Ваша должность соответствует данным из статистики.')
					end
				end
			end
			sampSendDialogResponse(dialogId, 0, _, _)
			getRankInStats = false
			return false
		end
	end
end

if sampevcheck then
	function sampev.onServerMessage(color, text)
			if text:find('Лидер .+ повысил до %d+ ранга') then
				lua_thread.create(function()
					wait(1)
					getRankInStats = true
					sampSendChat('/stats')
				end)
			end
			if text:find('{......}.+ выгнал вас из организации%. Причина: .+') then
				lua_thread.create(function()
					wait(1)
					getRankInStats = true
					sampSendChat('/stats')
				end)
			end
	end
end

function Screen()
	lua_thread.create(function()
		wait(500)
		setVirtualKeyDown(VK_F8, true)
		wait(10)
		setVirtualKeyDown(VK_F8, false)
	end)
end

function localtag()
	if imgui.BeginPopupModal(u8'Локальные тэги', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar) then
		imgui.CenterTextColoredRGB('Тэги:')
		--
		if imgui.Button('{my:name}') then setClipboardText('{my:name}'); GHsms('Тэг "{my:name}" скопирован в буфер обмена!') else imgui.Hint(u8'Нажмите, чтобы скопировать') end; imgui.SameLine(); imgui.TextColoredRGB('Выведет Ваше имя в РП формате')
		--
		if imgui.Button('{my:id}') then setClipboardText('{my:id}'); GHsms('Тэг "{my:id}" скопирован в буфер обмена!') else imgui.Hint(u8'Нажмите, чтобы скопировать') end; imgui.SameLine(); imgui.TextColoredRGB('Выведет Ваш Ид')
		--
		if imgui.Button('{my:rank}') then setClipboardText('{my:rank}'); GHsms('Тэг "{my:rank}" скопирован в буфер обмена!') else imgui.Hint(u8'Нажмите, чтобы скопировать') end; imgui.SameLine(); imgui.TextColoredRGB('Выведет Вашу должность')
		--
		if imgui.Button('{time}') then setClipboardText('{time}'); GHsms('Тэг "{time}" скопирован в буфер обмена!') else imgui.Hint(u8'Нажмите, чтобы скопировать.\nВ биндере использовать на новой строчке!') end; imgui.SameLine(); imgui.TextColoredRGB('Напишет "/time" в чат')
		--
		if imgui.Button('{screen}') then setClipboardText('{screen}'); GHsms('Тэг "{screen}" скопирован в буфер обмена!') else imgui.Hint(u8'Нажмите, чтобы скопировать.\nВ биндере советую использовать в строчке с текстом, иначе будет пустая строка в чате!') end; imgui.SameLine(); imgui.TextColoredRGB('Делает скриншот экрана (F8)')
		--
		if imgui.Button(u8'Закрыть##LocalTag', imgui.ImVec2(-1,20)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
end

function checklibs()
	log('Проверяю актуальность файлов игры!')
	local function DownloadFile(url, file)
		downloadUrlToFile(url,file,function(id,status)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		end
		end)
		while not doesFileExist(file) do
		wait(1000)
		end
	end
	if not doesFileExist(getWorkingDirectory()..'/config/Government Helper.ini') then
		if inicfg.save(cfg, 'Government Helper.ini') then log('Директория "Government Helper.ini" была создана!') end
	end
	if aupdate.v then
		autoupdate("https://raw.githubusercontent.com/Xkelling/Government-Helper/main/update.ini", '['..string.upper(thisScript().name)..'] ', 'https://www.blast.hk/threads/98005/')
	end
	if not facheck then
		GHsms("Отсутствует библиотека fAwesome5. Пытаюсь её установить.")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/fAwesome5.lua', getWorkingDirectory().."/lib/fAwesome5.lua")
		GHsms('Библиотека "fAwesome5" готова! Перезапускаю скрипт.')
		thisScript():reload()
		return false
	end
	if not doesFileExist(getWorkingDirectory() .. "/resource/fonts/fa-solid-900.ttf") then
		GHsms("Отсутствует файл шрифта fa-solid-900.ttf. Пытаюсь его установить.")
		createDirectory(getWorkingDirectory() .. "/resource/fonts/")
		DownloadFile('https://github.com/FortAwesome/Font-Awesome/raw/master/webfonts/fa-solid-900.ttf', getWorkingDirectory().."/resource/fonts/fa-solid-900.ttf")
		GHsms('Шрифт "fa-solid-900.ttf" готов! Перезапускаю скрипт.')
		thisScript():reload()
		return false
	end
	if not sampevcheck then
		GHsms("Отсутствует библиотека SAMP.lua. Пытаюсь её установить.")
		createDirectory(getWorkingDirectory() .. '/lib/samp')
		createDirectory(getWorkingDirectory() .. '/lib/samp/events')
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events.lua', getWorkingDirectory().."/lib/samp/events.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/raknet.lua', getWorkingDirectory().."/lib/samp/raknet.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/synchronization.lua', getWorkingDirectory().."/lib/samp/synchronization.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events/bitstream_io.lua', getWorkingDirectory().."/lib/samp/events/bitstream_io.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events/core.lua', getWorkingDirectory().."/lib/samp/events/core.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events/extra_types.lua', getWorkingDirectory().."/lib/samp/events/extra_types.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events/handlers.lua', getWorkingDirectory().."/lib/samp/events/handlers.lua")
		DownloadFile('https://github.com/Xkelling/Government-Helper/raw/main/samp/events/utils.lua', getWorkingDirectory().."/lib/samp/events/utils.lua")
		GHsms('Библиотека "SAMP.lua" готова! Перезапускаю скрипт.')
		thisScript():reload()
		return false
	end
	return true
end

if memory.tohex(getModuleHandle("samp.dll") + 0xBABE, 10, true ) == "E86D9A0A0083C41C85C0" then
		sampIsLocalPlayerSpawned = function()
				local res, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				return sampGetGamestate() == 3 and res and sampGetPlayerAnimationId(id) ~= 0
		end
end
