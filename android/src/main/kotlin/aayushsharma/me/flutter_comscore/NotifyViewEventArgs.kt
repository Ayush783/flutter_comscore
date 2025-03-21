package aayushsharma.me.flutter_comscore

import kotlinx.serialization.Serializable

@Serializable
data class NotifyViewEventArgs (
    val category: String,
    val eventData: HashMap<String, String> = HashMap<String, String>()
)