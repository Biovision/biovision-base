# frozen_string_literal: true

# Simple file uploader without any processing
class SimpleFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    slug = "#{model.id / 100}/#{model.id}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end

  def extension_blacklist
    %w[
      htm html action apk app bat bin cmd com command cpl csh exe gadget inf ins
      inx ipa isu job jse ksh lnk msc msi msp mst osx out paf pif prg ps1 reg
      rgs run scr sct shb shs u3p vb vbe vbs vbscript workflow ws wsf wsh 0xe
      73k 89k a6p ac acc acr actm ahk air app arscript as asb awk azw2 beam btm
      cel celx chm cof crt dek dld dmc docm dotm dxl ear ebm ebs ebs2 ecf eham
      elf es ex4 exopc ezs fas fky fpi frs fxp gs ham hms hpf hta iim ipf isp
      jar js jsx kix lo ls mam mcr mel mpx mrc ms ms mxe nexe obs ore otm pex
      plx potm ppam ppsm pptm prc pvd pwc pyc pyo qpx rbx rox rpj s2a sbs sca
      scar scb script smm spr tcp thm tlb tms udf upx url vlx vpm wcm widget wiz
      wpk wpm xap xbap xlam xlm xlsm xltm xqt xys zl9 dmg pkg php rb
    ]
  end
end
