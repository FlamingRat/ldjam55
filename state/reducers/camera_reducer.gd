extends Node
class_name CameraReducer


static func update_camera_position(state: Store.State, message: Store.Message) -> Store.State:
    state.camera_focus = message.payload
    return state
