class QrCodesController < ApplicationController
  def box
    @box = Box.find(params[:id])
    # Generate the URL for the box detail page; adjust as needed.
    url = url_for(@box)
    qrcode = RQRCode::QRCode.new(url)
    png = qrcode.as_png(size: 256)
    send_data png.to_s, type: 'image/png', disposition: 'inline'
  end

  def box_group
    @box_group = BoxGroup.find(params[:id])
    url = url_for(@box_group)
    qrcode = RQRCode::QRCode.new(url)
    png = qrcode.as_png(size: 256)
    send_data png.to_s, type: 'image/png', disposition: 'inline'
  end
end