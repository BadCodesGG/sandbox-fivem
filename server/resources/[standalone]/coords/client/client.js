const Wait = (ms) => new Promise(res => setTimeout(res, ms))
const drawText = (text, xoffset, yoffset) => {
    SetTextColour(255, 255, 0, 255)
    SetTextFont(8)
    SetTextScale(0.378, 0.378)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(xoffset, yoffset)
}

