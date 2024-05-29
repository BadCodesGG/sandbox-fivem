let showcoords = true

const id = GetPlayerServerId(PlayerId())

RegisterCommand('coords', () => {
    showcoords = !showcoords
}, false)

let gx,gy,gz,gh

const coordsTicker = setTick(async () => {
    const ped = PlayerPedId()
    if(showcoords === false) {
        await Wait(500)
        return
    }
    const [cx,cy,cz] = GetGameplayCamRot()
    const [x,y,z] = GetEntityCoords(ped)
    const h = GetEntityHeading(ped)
    gx = x.toFixed(2)
    gy = y.toFixed(2)
    gz = z.toFixed(2)
    gh = h.toFixed(2)
    drawText(`COORDS: ${x.toFixed(2)} ${y.toFixed(2)} ${z.toFixed(2)} ${h.toFixed(2)}`, 0.40, 0)
    drawText(`CAMROTATION ${cx.toFixed(2)} ${cy.toFixed(2)} ${cz.toFixed(2)}`, 0.40, 0.025)
    drawText(`ID: ${id}`, 0.40, 0.050)
})

let cam = null

RegisterCommand('createcam', () => {
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -797.12,328.78,220.99, -4.69,0.00,138.48, 78.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
})

RegisterCommand('copy', () => {
    const payload = JSON.stringify({
        msg: 'copy',
        payload: {
            x: gx,
            y: gy,
            z: gz,
            h: gh
        }
    })
    SendNuiMessage(payload)
})

RegisterCommand('copyv', () => {
    const payload = JSON.stringify({
        msg: 'copy',
        payload: `x = ${gx}, y = ${gy}, z = ${gz}, h = ${gh}`
    })
    SendNuiMessage(payload)
})

RegisterCommand('copys', () => {
    const payload = JSON.stringify({
        msg: 'copy',
        payload: `{['x'] = ${gx}, ['y'] = ${gy}, ['z'] = ${gz}, ['h'] = ${gh}}`
    })
    SendNuiMessage(payload)
})

RegisterCommand('copyd', () => {
    const payload = JSON.stringify({
        msg: 'copy',
        payload: `{x = ${gx}, y = ${gy}, z = ${gz}, h = ${gh}}`
    })
    SendNuiMessage(payload)
})

RegisterCommand('copyvals', () => {
    const payload = JSON.stringify({
        msg: 'copy',
        payload: `${gx}, ${gy}, ${gz}, ${gh}`
    })
    SendNuiMessage(payload)
})
