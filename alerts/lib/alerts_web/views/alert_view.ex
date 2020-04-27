defmodule AlertsWeb.AlertView do
  use AlertsWeb, :view
  require AlertsWeb.Helpers
  alias Alerts.Business.DB
  alias Alerts.Business.Files

  @alert_hours 4

  def render_date(date) do
    case date do
      nil -> Phoenix.HTML.Tag.content_tag(:em, "never")
      "" -> Phoenix.HTML.Tag.content_tag(:em, "never")
      _ -> date |> AlertsWeb.Helpers.format_date_relative_and_local()
    end
  end

  def render_date_relative(date) do
    case date do
      nil -> Phoenix.HTML.Tag.content_tag(:em, "never")
      "" -> Phoenix.HTML.Tag.content_tag(:em, "never")
      _ -> date |> AlertsWeb.Helpers.format_date_relative()
    end
  end

  def active_tab_class(current, active) do
    if current == active do
      "active"
    else
      ""
    end
  end

  def render_total(total) do
    case total do
      nil -> "-"
      _ -> total
    end
  end

  def render_source(source), do: source

  def render_status(%DB.Alert{status: "broken", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "broken#{old(date)}", class: "label label-danger")
  end

  def render_status(%DB.Alert{status: "bad", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "bad#{old(date)}", class: "label label-danger")
  end

  def render_status(%DB.Alert{status: "never run", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "never run#{old(date)}", class: "label label-info")
  end

  def render_status(%DB.Alert{status: "never refreshed", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "never refreshed#{old(date)}", class: "label label-info")
  end

  def render_status(%DB.Alert{status: "good", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "good#{old(date)}", class: "label label-success")
  end

  def render_status(%DB.Alert{status: "under threshold", last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "under threshold#{old(date)}",
      class: "label label-warning"
    )
  end

  def render_status(%DB.Alert{status: unknown, last_run: date}) do
    Phoenix.HTML.Tag.content_tag(:span, "#{unknown}#{old(date)}", class: "label label-danger")
  end

  def old(nil), do: ""

  def old(date) do
    case Timex.diff(Timex.now(), date, :hours) > @alert_hours do
      true -> " (*)"
      false -> ""
    end
  end

  def render_schedule(%DB.Alert{schedule: nil}), do: "manual"

  def render_schedule(%DB.Alert{schedule: schedule}),
    do:
      link(
        schedule,
        to: "https://crontab.guru/#" <> String.replace(schedule, " ", "_"),
        target: "_blank"
      )

  def render_history(%DB.Alert{} = a) do
    svg =
      raw("""
      <svg class='bi bi-clock-history' width='1em' height='1em' viewBox='0 0 16 16' fill='currentColor' xmlns='http://www.w3.org/2000/svg'>
      <path fill-rule='evenodd' d='M8.515 1.019A7 7 0 008 1V0a8 8 0 01.589.022l-.074.997zm2.004.45a7.003 7.003 0 00-.985-.299l.219-.976c.383.086.76.2 1.126.342l-.36.933zm1.37.71a7.01 7.01 0 00-.439-.27l.493-.87a8.025 8.025 0 01.979.654l-.615.789a6.996 6.996 0 00-.418-.302zm1.834 1.79a6.99 6.99 0 00-.653-.796l.724-.69c.27.285.52.59.747.91l-.818.576zm.744 1.352a7.08 7.08 0 00-.214-.468l.893-.45a7.976 7.976 0 01.45 1.088l-.95.313a7.023 7.023 0 00-.179-.483zm.53 2.507a6.991 6.991 0 00-.1-1.025l.985-.17c.067.386.106.778.116 1.17l-1 .025zm-.131 1.538c.033-.17.06-.339.081-.51l.993.123a7.957 7.957 0 01-.23 1.155l-.964-.267c.046-.165.086-.332.12-.501zm-.952 2.379c.184-.29.346-.594.486-.908l.914.405c-.16.36-.345.706-.555 1.038l-.845-.535zm-.964 1.205c.122-.122.239-.248.35-.378l.758.653a8.073 8.073 0 01-.401.432l-.707-.707z' clip-rule='evenodd'/>
      <path fill-rule='evenodd' d='M8 1a7 7 0 104.95 11.95l.707.707A8.001 8.001 0 118 0v1z' clip-rule='evenodd'/>
      <path fill-rule='evenodd' d='M7.5 3a.5.5 0 01.5.5v5.21l3.248 1.856a.5.5 0 01-.496.868l-3.5-2A.5.5 0 017 9V3.5a.5.5 0 01.5-.5z' clip-rule='evenodd'/>
      </svg>
      """)

    link(
      svg,
      to:
        Application.get_env(:alerts, :git_browser) <>
          Files.normalize(a.context) <>
          "/commits/master/" <>
          Files.filename(a.id, a.name),
      target: "_blank"
    )
  end

  def render_download_icon() do
    raw("""
        <svg class='bi bi-download' width='1em' height='1em' viewBox='0 0 16 16' fill='currentColor' xmlns='http://www.w3.org/2000/svg'>
      <path fill-rule='evenodd' d='M.5 8a.5.5 0 01.5.5V12a1 1 0 001 1h12a1 1 0 001-1V8.5a.5.5 0 011 0V12a2 2 0 01-2 2H2a2 2 0 01-2-2V8.5A.5.5 0 01.5 8z' clip-rule='evenodd'/>
      <path fill-rule='evenodd' d='M5 7.5a.5.5 0 01.707 0L8 9.793 10.293 7.5a.5.5 0 11.707.707l-2.646 2.647a.5.5 0 01-.708 0L5 8.207A.5.5 0 015 7.5z' clip-rule='evenodd'/>
      <path fill-rule='evenodd' d='M8 1a.5.5 0 01.5.5v8a.5.5 0 01-1 0v-8A.5.5 0 018 1z' clip-rule='evenodd'/>
    </svg>
    """)
  end
end
