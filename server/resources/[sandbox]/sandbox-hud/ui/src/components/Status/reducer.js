export const initialState = {
    health: 100,
    maxHealth: 100,
    armor: 100,
    isDead: false,
    buffDefs:
        process.env.NODE_ENV == 'production'
            ? {}
            : {
                  VOIP: {
                      icon: 'skull',
                      duration: -1,
                      type: 'permanent',
                  },
                  VAL: {
                      icon: 'crown',
                      duration: -1,
                      type: 'value',
                  },
              },
    buffs:
        process.env.NODE_ENV == 'production'
            ? []
            : [
                  {
                      buff: 'VOIP',
                      override: 'S+',
                      val: 100,
                  },
                  {
                      buff: 'VAL',
                      val: 75,
                  },
              ],
    statuses:
        process.env.NODE_ENV == 'production'
            ? []
            : [
                  {
                      name: 'PLAYER_HUNGER',
                      max: 100,
                      value: 45,
                      icon: 'drumstick-bite',
                      color: '#ca5fe8',
                      flash: false,
                      options: {
                          hideZero: false,
                          order: 5,
                      },
                  },
                  {
                      name: 'PLAYER_THIRST',
                      max: 100,
                      value: 22,
                      icon: 'whiskey-glass',
                      color: '#07bdf0',
                      flash: false,
                      options: {
                          hideZero: false,
                          order: 6,
                      },
                  },
                  {
                      name: 'PLAYER_STRESS',
                      max: 100,
                      value: 66,
                      icon: 'face-explode',
                      color: '#de3333',
                      flash: false,
                      options: {
                          hideZero: false,
                          order: 4,
                      },
                  },
                  {
                      name: 'radio-freq',
                      max: 100,
                      value: '333.3',
                      icon: 'walkie-talkie',
                      color: '#de3333',
                      flash: false,
                      options: {
                          hideZero: false,
                          order: 4,
                          force: 'numbers',
                      },
                  },
              ],
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SET_DEAD':
            return {
                ...state,
                isDead: action.payload.state,
            };
        case 'SHOW_HUD':
        case 'UPDATE_HP':
            return {
                ...state,
                health: action.payload.hp,
                maxHealth: action.payload.maxHp,
                armor: action.payload.armor,
            };
        case 'REGISTER_STATUS':
            return {
                ...state,
                statuses: [...state.statuses, action.payload.status],
            };
        case 'RESET_STATUSES':
            return {
                ...state,
                statuses: Array(),
            };
        case 'UPDATE_STATUS':
            return {
                ...state,
                statuses: state.statuses.map((status, i) =>
                    status.name == action.payload.status.name
                        ? { ...status, ...action.payload.status }
                        : status,
                ),
            };
        case 'UPDATE_STATUS_VALUE':
            return {
                ...state,
                statuses: state.statuses.map((status, i) =>
                    status.name == action.payload.name
                        ? { ...status, value: action.payload.value }
                        : status,
                ),
            };
        case 'UPDATE_STATUSES':
            return {
                ...state,
                statuses: action.payload.statuses,
            };
        case 'REGISTER_BUFF':
            return {
                ...state,
                buffDefs: {
                    ...state.buffDefs,
                    [action.payload.id]: action.payload.data,
                },
            };
        case 'BUFF_APPLIED':
            return {
                ...state,
                buffs: [...state.buffs, action.payload.instance],
            };
        case 'BUFF_APPLIED_UNIQUE':
            if (
                state.buffs.filter(
                    (b) => b?.buff == action.payload.instance?.buff,
                ).length > 0
            )
                return {
                    ...state,
                    buffs: state.buffs.map((b) => {
                        if (b?.buff == action.payload.instance?.buff)
                            return { ...action.payload.instance };
                        else return b;
                    }),
                };
            else {
                return {
                    ...state,
                    buffs: [...state.buffs, action.payload.instance],
                };
            }
        case 'UPDATE_BUFF_ICON':
            return {
                ...state,
            };
        case 'REMOVE_BUFF_BY_TYPE':
            return {
                ...state,
                buffs: state.buffs.filter(
                    (b) => b?.buff != action.payload.type,
                ),
            };
        case 'UI_RESET':
            return {
                ...initialState,
                buffDefs: { ...state.buffDefs },
                buffs: [...state.buffs],
            };
        default:
            return state;
    }
};
