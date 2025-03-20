package aayushsharma.me.flutter_comscore

import kotlinx.serialization.Serializable

@Serializable
data class StartComscoreArgs(
    val userConsent: Int?,
    val debug: Boolean = false,
    val isChildDirected: Boolean = false,
)